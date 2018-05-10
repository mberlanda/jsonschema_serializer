RSpec.describe JsonschemaSerializer::Builder do
  let(:builder) { JsonschemaSerializer::Builder }

  it "should generate an empty object" do
    expect(builder.build.schema).to eq({type: :object, properties: {}})
  end

end
