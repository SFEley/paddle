require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/bidsheets" do
  before(:each) do
    @response = request("/bidsheets")
  end
end