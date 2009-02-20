require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a bid exists" do
  Bid.all.destroy!
  request(resource(:bids), :method => "POST", 
    :params => { :bid => { :id => nil }})
end

describe "resource(:bids)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:bids))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of bids" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a bid exists" do
    before(:each) do
      @response = request(resource(:bids))
    end
    
    it "has a list of bids" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Bid.all.destroy!
      @response = request(resource(:bids), :method => "POST", 
        :params => { :bid => { :id => nil }})
    end
    
    it "redirects to resource(:bids)" do
      @response.should redirect_to(resource(Bid.first), :message => {:notice => "bid was successfully created"})
    end
    
  end
end

describe "resource(@bid)" do 
  describe "a successful DELETE", :given => "a bid exists" do
     before(:each) do
       @response = request(resource(Bid.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:bids))
     end

   end
end

describe "resource(:bids, :new)" do
  before(:each) do
    @response = request(resource(:bids, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@bid, :edit)", :given => "a bid exists" do
  before(:each) do
    @response = request(resource(Bid.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@bid)", :given => "a bid exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Bid.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @bid = Bid.first
      @response = request(resource(@bid), :method => "PUT", 
        :params => { :bid => {:id => @bid.id} })
    end
  
    it "redirect to the bid show action" do
      @response.should redirect_to(resource(@bid))
    end
  end
  
end

