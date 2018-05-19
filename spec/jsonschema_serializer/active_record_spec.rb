RSpec.describe 'JsonschemaSerializer::ActiveRecord' do

  subject { JsonschemaSerializer::ActiveRecord }

  it { subject.respond_to?(:from_active_record) }

  class Serializer
    include JsonschemaSerializer::ActiveRecord
  end

  Column = Struct.new('Column', :type, :name, :default)
  Record = Struct.new('Record', :columns)

  context 'from_active_record' do
    it 'should work for an empty record' do
      record = Record.new([])

      actual = Serializer.from_active_record(record)
      expect(actual.schema).to eq(type: :object, properties: {})
    end
  end
end
