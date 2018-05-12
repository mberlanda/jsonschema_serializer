RSpec.describe JsonschemaSerializer::Builder do
  let(:builder) { JsonschemaSerializer::Builder }

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
end
