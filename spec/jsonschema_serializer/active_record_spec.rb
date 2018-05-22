RSpec.describe 'JsonschemaSerializer::ActiveRecord' do
  subject { JsonschemaSerializer::ActiveRecord }

  it { subject.respond_to?(:from_active_record) }

  SqlTypeMetadata = Struct.new('SqlTypeMetadata', :type)
  Column = Struct.new('Column', :sql_type_metadata, :name, :default)
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

    context 'a one-column record' do
      let(:sql_type) { SqlTypeMetadata.new(:decimal) }
      let(:column) { Column.new(sql_type, 'present') }
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

    context 'a n-columns record' do
      let(:decimal_type) { SqlTypeMetadata.new(:decimal) }
      let(:text_type) { SqlTypeMetadata.new(:text) }
      let(:x_column) { Column.new(decimal_type, 'x') }
      let(:t_column) { Column.new(text_type, 't') }
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

      it 'should manipulate a dup of columns' do
        step1 = subject.from_active_record(record, only: %w[x])
        expect(step1.schema).to eq(x_schema)

        step2 = subject.from_active_record(record, only: %w[t])
        expect(step2.schema).to eq(t_schema)
      end
    end
  end
end
