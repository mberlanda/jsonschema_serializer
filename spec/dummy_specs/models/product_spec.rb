# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, rails: true do
  context 'a default jsonschema serialization' do
    let(:builder) { JsonschemaSerializer::ActiveRecord.from_model(Product) }

    it 'should generate a schema' do
      expected_schema = {
        type: :object,
        properties: {
          'id' => { type: :integer },
          'name' => { type: :string },
          'price' => { type: :number },
          'available' => { type: :boolean },
          'description' => { type: :string },
          'created_at' => { type: :string },
          'updated_at' => { type: :string }
        },
        title: 'Product',
        required: [:name]
      }
      expect(builder.schema).to eq(expected_schema)
    end
  end
end
