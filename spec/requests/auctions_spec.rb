require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a auction exists" do
  Auction.all.destroy!
  request(resource(:auctions), :method => "POST", 
    :params => { :auction => { :id => nil }})
end

describe "resource(:auctions)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:auctions))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of auctions" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a auction exists" do
    before(:each) do
      @response = request(resource(:auctions))
    end
    
    it "has a list of auctions" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Auction.all.destroy!
      @response = request(resource(:auctions), :method => "POST", 
        :params => { :auction => { :id => nil }})
    end
    
    it "redirects to resource(:auctions)" do
      @response.should redirect_to(resource(Auction.first), :message => {:notice => "auction was successfully created"})
    end
    
  end
end

describe "resource(@auction)" do 
  describe "a successful DELETE", :given => "a auction exists" do
     before(:each) do
       @response = request(resource(Auction.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:auctions))
     end

   end
end

describe "resource(:auctions, :new)" do
  before(:each) do
    @response = request(resource(:auctions, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@auction, :edit)", :given => "a auction exists" do
  before(:each) do
    @response = request(resource(Auction.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@auction)", :given => "a auction exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Auction.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @auction = Auction.first
      @response = request(resource(@auction), :method => "PUT", 
        :params => { :auction => {:id => @auction.id} })
    end
  
    it "redirect to the auction show action" do
      @response.should redirect_to(resource(@auction))
    end
  end
  
end

