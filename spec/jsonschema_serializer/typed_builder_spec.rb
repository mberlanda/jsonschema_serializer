# frozen_string_literal: true

RSpec.describe JsonschemaSerializer::TypedBuilder do
  let(:builder) { JsonschemaSerializer::TypedBuilder }

  it 'should generate an empty object' do
    expect(builder.build.schema).to eq(type: :object, properties: {})
  end

  it 'should generate add some attributes to the root object' do
    actual = builder.build do |b|
      b.title 'a title'
      b.description 'a description'
      b.required :a, :b, :c
    end

    expect(actual.schema).to eq(
      title: 'a title',
      description: 'a description',
      required: [:a, :b, :c],
      type: :object,
      properties: {}
    )
  end

  context 'properties on root object' do
    it 'should add simple array attributes' do
      actual = builder.build do |b|
        b.properties.tap do |p|
          p.merge! b.array :ary, items: b._string(default: 'foo')
        end
      end

      expect(actual.schema).to eq(
        type: :object,
        properties: {
          ary: {
            type: :array,
            items: {
              type: :string,
              default: 'foo'
            }
          }
        }
      )
    end

    it 'should add complex array attributes' do
      actual = builder.build do |b|
        subscriber = b._object title: :subscriber, required: [:age] do |prop|
          prop.merge! b.string :first_name, title: 'First Name'
          prop.merge! b.string :last_name, title: 'Last Name'
          prop.merge! b.integer :age, title: 'Age'
        end

        b.properties.tap do |p|
          p.merge! b.array :subscribers, minItems: 1, items: subscriber
        end
      end

      expect(actual.schema).to eq(
        type: :object,
        properties: {
          subscribers: {
            type: :array,
            minItems: 1,
            items: {
              type: :object,
              title: :subscriber,
              required: [:age],
              properties: {
                first_name: {
                  type: :string,
                  title: 'First Name'
                },
                last_name: {
                  type: :string,
                  title: 'Last Name'
                },
                age: {
                  type: :integer,
                  title: 'Age'
                }
              }
            }
          }
        }
      )
    end

    it 'should add boolean attributes' do
      actual = builder.build do |b|
        b.properties.tap do |p|
          p.merge! b.boolean :a, default: true
        end
      end

      expect(actual.schema).to eq(
        type: :object,
        properties: {
          a: {
            type: :boolean,
            default: true
          }
        }
      )
    end

    it 'should add integer attributes' do
      actual = builder.build do |b|
        b.properties.tap do |p|
          p.merge! b.integer :b, maximum: 10
        end
      end

      expect(actual.schema).to eq(
        type: :object,
        properties: {
          b: {
            type: :integer,
            maximum: 10
          }
        }
      )
    end

    it 'should add number attributes' do
      actual = builder.build do |b|
        b.properties.tap do |p|
          p.merge! b.number :c, minimum: 3
        end
      end

      expect(actual.schema).to eq(
        type: :object,
        properties: {
          c: {
            type: :number,
            minimum: 3
          }
        }
      )
    end

    it 'should add string attributes' do
      actual = builder.build do |b|
        b.properties.tap do |p|
          p.merge! b.string :d, description: 'abc'
        end
      end

      expect(actual.schema).to eq(
        type: :object,
        properties: {
          d: {
            type: :string,
            description: 'abc'
          }
        }
      )
    end
  end

  describe 'generate valid json schemas' do
    let(:schema) do
      builder.build do |b|
        b.title 'a title'
        b.description 'a description'
        b.required :a, :b, :c
        b.properties.tap do |p|
          p.merge! b.string :a, minLength: 2
          p.merge! b.number :b, maximum: 10
          p.merge! b.array :c, minItems: 1, items: b._integer
          p.merge! b.boolean :d
          p.merge! b.integer :e, enum: [1, 2, 3]
        end
      end.schema
    end

    it 'should fail for empty data' do
      expect(JSON::Validator.validate(schema, {})).to eq(false)
    end

    it 'should fail for missing required keys' do
      expect(JSON::Validator.validate(schema, a: 'ab')).to eq(false)
    end

    context 'irrespective of required keys constraints' do
      let(:valid_data) { { a: 'ab', b: 9.9, c: [1] } }

      it 'should succeed with valid data' do
        expect(JSON::Validator.validate(schema, valid_data)).to eq(true)
      end

      it 'should fail for string minLenght' do
        min_length = valid_data.merge(a: '')
        expect(JSON::Validator.validate(schema, min_length)).to eq(false)
      end

      it 'should fail for number maximum' do
        maximum = valid_data.merge(b: 10.1)
        expect(JSON::Validator.validate(schema, maximum)).to eq(false)
      end

      it 'should fail for array minItems' do
        min_items = valid_data.merge(c: [])
        expect(JSON::Validator.validate(schema, min_items)).to eq(false)
      end

      it 'should fail for integer enum' do
        enum_fail = valid_data.merge(e: 4)
        expect(JSON::Validator.validate(schema, enum_fail)).to eq(false)
      end

      it 'should fail for wrong type' do
        type_fail = valid_data.merge(d: 4)
        expect(JSON::Validator.validate(schema, type_fail)).to eq(false)
      end
    end
  end

  describe 'dsl for empty types' do
    subject { builder.new }

    it { expect(subject._boolean).to eq(JsonschemaSerializer::Types::Boolean.empty) }
    it { expect(subject._integer).to eq(JsonschemaSerializer::Types::Integer.empty) }
    it { expect(subject._number).to eq(JsonschemaSerializer::Types::Number.empty) }
    it { expect(subject._object).to eq(JsonschemaSerializer::Types::Object.empty) }
    it { expect(subject._string).to eq(JsonschemaSerializer::Types::String.empty) }
  end

  context '.to_json' do
    let(:instance) { builder.new }

    it 'should dump a prettified json by default' do
      # Testing with regex since jruby add more \n
      expected = /{\n  \"type\": \"object\",\n  \"properties\": {\n+  }\n}/
      expect(instance.to_json).to match(expected)
    end

    it 'should allow to dump also not prettified json' do
      expected = '{"type":"object","properties":{}}'
      expect(instance.to_json(pretty: false)).to eq(expected)
    end
  end
end
