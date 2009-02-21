require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/import" do
  before(:each) do
    @response = request("/import")
  end
end