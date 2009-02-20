class Person
  include DataMapper::Resource
  
  property :id, Serial
  property :last_name, String, :nullable => false
  property :first_name, String, :nullable => false
  property :email, String, :unique => true, :format => :email_address
  property :phone, String
  property :paddle, Integer

  validates_is_unique :first_name, :scope => :last_name
  
  def self.by_names
    all(:order => [:last_name])
  end

  def self.by_paddles
    all(:order => [:paddle, :last_name])
  end
  
  def ordered_name
    if first_name.blank? 
      last_name
    else
      "#{last_name}, #{first_name}"
    end
  end
  
  def common_name
    "#{first_name} #{last_name}"
  end
  
  def paddle_name
    "#{paddle} - #{common_name}"
  end
      
      
end
