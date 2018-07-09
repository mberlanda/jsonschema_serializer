# frozen_string_literal: true

RSpec.describe 'JsonschemaSerializer errors' do
  context 'AllowedExcludedError' do
    it 'should be an ArgumentError' do
      expect do
        raise JsonschemaSerializer::AllowedExcludedError, 'a custom message'
      end.to raise_error(ArgumentError)
    end
  end
end
