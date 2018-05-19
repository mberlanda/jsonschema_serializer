RSpec.describe 'JsonschemaSerializer::ActiveRecord' do
  subject { JsonschemaSerializer::ActiveRecord }

  it { subject.respond_to?(:from_active_record) }

  class Serializer
    include JsonschemaSerializer::ActiveRecord
  end

  Column = Struct.new('Column', :type, :name, :default)
  Record = Struct.new('Record', :columns)

  describe 'from_active_record' do
    let(:empty_schema) { { type: :object, properties: {} } }

    context 'an empty record' do
      let(:record) { Record.new([]) }

      it 'should build' do
        actual = Serializer.from_active_record(record)
        expect(actual.schema).to eq(empty_schema)
      end

      it 'should except' do
        actual = Serializer.from_active_record(record, except: %w[a b c])
        expect(actual.schema).to eq(empty_schema)
      end

      it 'should only' do
        actual = Serializer.from_active_record(record, only: %w[a b c])
        expect(actual.schema).to eq(empty_schema)
      end
    end

    context 'a one-colum record' do
      let(:column) { Column.new(:decimal, 'present') }
      let(:record) { Record.new([column]) }

      it 'should build' do
        actual = Serializer.from_active_record(record)
        expect(actual.schema).to eq(
          type: :object,
          properties: {
            'present' => { type: :number }
          }
        )
      end

      it 'should except' do
        actual = Serializer.from_active_record(record, except: %w[missing])
        expect(actual.schema).to eq(
          type: :object,
          properties: {
            'present' => { type: :number }
          }
        )
      end

      it 'should only' do
        actual = Serializer.from_active_record(record, only: %w[missing])
        expect(actual.schema).to eq(empty_schema)
      end
    end
  end
end
