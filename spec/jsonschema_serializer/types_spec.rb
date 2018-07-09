# frozen_string_literal: true

RSpec.describe 'JsonschemaSerializer types' do
  describe JsonschemaSerializer::Types::Base do
    subject { JsonschemaSerializer::Types::Base }

    it { subject.respond_to?(:default_hash) }
    it { expect(subject.default_hash).to eq({}) }

    it { subject.respond_to?(:empty) }
    it { expect(subject.empty).to eq({}) }
    it { expect(subject.empty(a: 1)).to eq(a: 1) }

    it { subject.respond_to?(:named) }
    it { expect(subject.named(:foo)).to eq(foo: {}) }
    it { expect(subject.named(:foo, bar: :baz)).to eq(foo: { bar: :baz }) }
  end

  describe JsonschemaSerializer::Types::Array do
    subject { JsonschemaSerializer::Types::Array }

    it { expect(subject.superclass).to eq(JsonschemaSerializer::Types::Base) }
    it { expect(subject.default_hash).to eq(type: :array) }

    it 'needs items key' do
      expect { subject.empty }.to raise_error(ArgumentError, /items/)
    end

    it { expect(subject.empty(items: {})).to eq(type: :array, items: {}) }
    it do
      expect(subject.named(:foo, items: {})).to eq(
        foo: { type: :array, items: {} }
      )
    end

    it do
      expect(subject.named(:foo, bar: :baz, items: {})).to eq(
        foo: { type: :array, bar: :baz, items: {} }
      )
    end
  end

  describe JsonschemaSerializer::Types::Boolean do
    subject { JsonschemaSerializer::Types::Boolean }

    it { expect(subject.superclass).to eq(JsonschemaSerializer::Types::Base) }
    it { expect(subject.default_hash).to eq(type: :boolean) }
    it { expect(subject.empty).to eq(type: :boolean) }
    it { expect(subject.empty(a: 1)).to eq(type: :boolean, a: 1) }
    it { expect(subject.named(:foo)).to eq(foo: { type: :boolean }) }
    it do
      expect(subject.named(:foo, bar: :baz)).to eq(
        foo: { type: :boolean, bar: :baz }
      )
    end
  end

  describe JsonschemaSerializer::Types::Integer do
    subject { JsonschemaSerializer::Types::Integer }

    it { expect(subject.superclass).to eq(JsonschemaSerializer::Types::Base) }
    it { expect(subject.default_hash).to eq(type: :integer) }
    it { expect(subject.empty).to eq(type: :integer) }
    it { expect(subject.empty(a: 1)).to eq(type: :integer, a: 1) }
    it { expect(subject.named(:foo)).to eq(foo: { type: :integer }) }
    it do
      expect(subject.named(:foo, bar: :baz)).to eq(
        foo: { type: :integer, bar: :baz }
      )
    end
  end

  describe JsonschemaSerializer::Types::Number do
    subject { JsonschemaSerializer::Types::Number }

    it { expect(subject.superclass).to eq(JsonschemaSerializer::Types::Base) }
    it { expect(subject.default_hash).to eq(type: :number) }
    it { expect(subject.empty).to eq(type: :number) }
    it { expect(subject.empty(a: 1)).to eq(type: :number, a: 1) }
    it { expect(subject.named(:foo)).to eq(foo: { type: :number }) }
    it do
      expect(subject.named(:foo, bar: :baz)).to eq(
        foo: { type: :number, bar: :baz }
      )
    end
  end

  describe JsonschemaSerializer::Types::Object do
    subject { JsonschemaSerializer::Types::Object }

    it { expect(subject.superclass).to eq(JsonschemaSerializer::Types::Base) }
    it { expect(subject.default_hash).to eq(type: :object, properties: {}) }
    it { expect(subject.empty).to eq(type: :object, properties: {}) }
    it { expect(subject.empty(a: 1)).to eq(type: :object, properties: {}, a: 1) }
    it { expect(subject.named(:foo)).to eq(foo: { type: :object, properties: {} }) }
    it do
      expect(subject.named(:foo, bar: :baz)).to eq(
        foo: { type: :object, properties: {}, bar: :baz }
      )
    end
  end

  describe JsonschemaSerializer::Types::String do
    subject { JsonschemaSerializer::Types::String }

    it { expect(subject.superclass).to eq(JsonschemaSerializer::Types::Base) }
    it { expect(subject.default_hash).to eq(type: :string) }
    it { expect(subject.empty).to eq(type: :string) }
    it { expect(subject.empty(a: 1)).to eq(type: :string, a: 1) }
    it { expect(subject.named(:foo)).to eq(foo: { type: :string }) }
    it do
      expect(subject.named(:foo, bar: :baz)).to eq(
        foo: { type: :string, bar: :baz }
      )
    end
  end
end
