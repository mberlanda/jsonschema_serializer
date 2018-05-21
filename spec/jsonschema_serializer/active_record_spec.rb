RSpec.describe 'JsonschemaSerializer::ActiveRecord' do
  subject { JsonschemaSerializer::ActiveRecord }

  it { subject.respond_to?(:from_active_record) }

  Column = Struct.new('Column', :type, :name, :default)
  Record = Struct.new('Record', :columns)

  describe 'from_active_record' do
    let(:empty_schema) { { type: :object, properties: {} } }

    context 'an empty record' do
      let(:record) { Record.new([]) }

      it 'should build' do
        actual = subject.from_active_record(record)
        expect(actual.schema).to eq(empty_schema)
      end

      it 'should except' do
        actual = subject.from_active_record(record, except: %w[a b c])
        expect(actual.schema).to eq(empty_schema)
      end

      it 'should only' do
        actual = subject.from_active_record(record, only: %w[a b c])
        expect(actual.schema).to eq(empty_schema)
      end
    end

    context 'a one-colum record' do
      let(:column) { Column.new(:decimal, 'present') }
      let(:record) { Record.new([column]) }

      it 'should build' do
        actual = subject.from_active_record(record)
        expect(actual.schema).to eq(
          type: :object,
          properties: {
            'present' => { type: :number }
          }
        )
      end

      it 'should except' do
        actual = subject.from_active_record(record, except: %w[missing])
        expect(actual.schema).to eq(
          type: :object,
          properties: {
            'present' => { type: :number }
          }
        )
      end

      it 'should only' do
        actual = subject.from_active_record(record, only: %w[missing])
        expect(actual.schema).to eq(empty_schema)
      end
    end

    context 'a one-colum record' do
      let(:x_column) { Column.new(:decimal, 'x') }
      let(:t_column) { Column.new(:text, 't') }
      let(:record) { Record.new([x_column, t_column]) }

      let(:x_schema) do
        { type: :object, properties: { 'x' => { type: :number } } }
      end
      let(:t_schema) do
        { type: :object, properties: { 't' => { type: :string } } }
      end

      it 'should build' do
        actual = subject.from_active_record(record)
        expect(actual.schema).to eq(
          type: :object,
          properties: {
            'x' => { type: :number },
            't' => { type: :string }
          }
        )
      end

      it 'should except missing' do
        actual = subject.from_active_record(record, except: %w[missing])
        expect(actual.schema).to eq(
          type: :object,
          properties: {
            'x' => { type: :number },
            't' => { type: :string }
          }
        )
      end

      it 'should except x' do
        actual = subject.from_active_record(record, except: %w[x])
        expect(actual.schema).to eq(t_schema)
      end

      it 'should except y' do
        actual = subject.from_active_record(record, except: %w[t])
        expect(actual.schema).to eq(x_schema)
      end

      it 'should only missing' do
        actual = subject.from_active_record(record, only: %w[missing])
        expect(actual.schema).to eq(empty_schema)
      end

      it 'should only x' do
        actual = subject.from_active_record(record, only: %w[x])
        expect(actual.schema).to eq(x_schema)
      end

      it 'should only y' do
        actual = subject.from_active_record(record, only: %w[t])
        expect(actual.schema).to eq(t_schema)
      end
    end
  end
end
