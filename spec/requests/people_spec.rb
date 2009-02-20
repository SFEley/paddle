require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a person exists" do
  Person.all.destroy!
  request(resource(:people), :method => "POST", 
    :params => { :person => { :id => nil }})
end

describe "resource(:people)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:people))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of people" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a person exists" do
    before(:each) do
      @response = request(resource(:people))
    end
    
    it "has a list of people" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Person.all.destroy!
      @response = request(resource(:people), :method => "POST", 
        :params => { :person => { :id => nil }})
    end
    
    it "redirects to resource(:people)" do
      @response.should redirect_to(resource(Person.first), :message => {:notice => "person was successfully created"})
    end
    
  end
end

describe "resource(@person)" do 
  describe "a successful DELETE", :given => "a person exists" do
     before(:each) do
       @response = request(resource(Person.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:people))
     end

   end
end

describe "resource(:people, :new)" do
  before(:each) do
    @response = request(resource(:people, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@person, :edit)", :given => "a person exists" do
  before(:each) do
    @response = request(resource(Person.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@person)", :given => "a person exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Person.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @person = Person.first
      @response = request(resource(@person), :method => "PUT", 
        :params => { :person => {:id => @person.id} })
    end
  
    it "redirect to the person show action" do
      @response.should redirect_to(resource(@person))
    end
  end
  
end

