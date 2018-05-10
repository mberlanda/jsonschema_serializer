RSpec.describe JsonschemaSerializer::Builder do
  let(:builder) { JsonschemaSerializer::Builder }

  it "should generate an empty object" do
    expect(builder.build.schema).to eq({type: :object, properties: {}})
  end

  it "should generate add some attributes to the root object" do
    actual = builder.build do |b|
      b.title "a title"
      b.description "a description"
      b.required :a, :b, :c
    end

    expect(actual.schema).to eq({
      title: "a title",
      description: "a description",
      required: [:a, :b, :c],
      type: :object,
      properties: {}
    })
  end
end
