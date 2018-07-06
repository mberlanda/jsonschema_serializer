# frozen_string_literal: true

RSpec.describe 'JsonschemaSerializer::FilterUtilities' do
  class TestClass
    include JsonschemaSerializer::FilterUtilities
  end

  subject { TestClass }

  it { subject.respond_to?(:allowed_attributes) }
  it { subject.respond_to?(:allowed_obj_attributes) }
  it { subject.respond_to?(:excluded_attributes) }
  it { subject.respond_to?(:excluded_obj_attributes) }

  context 'allowed attributes' do
    class AttributesSerializer
      include JsonschemaSerializer::FilterUtilities
      allowed_attributes :a, :b, :c
      allowed_attributes 'b', 'c', 'd'
      excluded_attributes :a, 'b'
    end

    it 'should store multiple allowed_attributes' do
      expect(AttributesSerializer.allowed_obj_attributes)
        .to eq(%w[a b c b c d])
    end

    it 'should store multiple allowed_attributes' do
      expect(AttributesSerializer.excluded_obj_attributes)
        .to eq(%w[a b])
    end
  end
end
