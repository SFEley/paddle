class Person
  include DataMapper::Resource
  
  property :id, Serial
  property :last_name, String, :nullable => false
  property :first_name, String, :nullable => false
  property :email, String, :unique => true
  property :phone, String
  property :paddle, Integer

  validates_is_unique :first_name, :scope => :last_name
  validates_is_number :paddle, :allow_nil => true
  validates_format :email, :as => :email_address, :allow_nil => true
  
  has n, :selling, :class_name => "Auction", :child_key => [:seller_id]
  has n, :bids, :child_key => [:buyer_id]
  has n, :buying, :through => :bids, :class_name => "Auction", :winning => true, :order => [:title.asc], :child_key => [:buyer_id]
  has n, :payments
  
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
    if paddle
      "#{paddle} - #{common_name}"
    else
      common_name
    end
  end
  
  def total_payments
    payments.sum(:amount) || 0
  end
  
  def total_purchases
    bids.sum(:amount, :winning => true) || 0
  end
  
  def balance
    total_purchases - total_payments
  end
      
      
end
