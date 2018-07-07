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
    class AllowingSerializer
      include JsonschemaSerializer::FilterUtilities
      allowed_attributes :a, :b, :c
      allowed_attributes 'b', 'c', 'd'
    end

    it 'should store multiple allowed_attributes' do
      expect(AllowingSerializer.allowed_obj_attributes)
        .to eq(%w[a b c b c d])
    end

    it 'raises if declared after an excluded_attributes' do
      expect do
        class InvalidSerializer
          include JsonschemaSerializer::FilterUtilities
          excluded_attributes :a, :b, :c
          allowed_attributes 'b', 'c', 'd'
        end.to raise_error(JsonschemaSerializer::AllowedExcludedError)
      end
    end
  end

  context 'excluded attributes' do
    class ExcludingSerializer
      include JsonschemaSerializer::FilterUtilities
      excluded_attributes :a, 'b'
    end

    it 'should store multiple excluded_attributes' do
      expect(ExcludingSerializer.excluded_obj_attributes)
        .to eq(%w[a b])
    end
  end
end
