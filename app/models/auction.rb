
class Auction
  TYPES = ['Live', 'Silent', 'Party']
  
  include DataMapper::Resource
  
  property :id, Serial
  property :code, String, :unique => true, :format => /[A-Z]\d+/
  property :title, String, :unique => true, :nullable => false
  property :auction_type, String, :default => 'Live'
  property :description, Text
  property :quantity, Integer, :default => 1
  property :minimum_bid, BigDecimal, :precision => 6, :scale => 2, :default => 10.0
  property :status, Enum[:open, :closed], :default => :open, :writer => :protected
  
  validates_within :auction_type, :set => TYPES
  validates_is_number :quantity
  validates_is_number :minimum_bid
  
  belongs_to :seller, :class_name => "Person", :child_key => [:seller_id]
  has n, :bids, :order => [:amount.desc]
  has n, :buyers, :through => :bids, :class_name => "Person", :winning => true, :order => [:amount.desc], :child_key => [:buyer_id]
  
  def close
    transaction do |txn|
      quantity.times do |q|
        bids[q].update_attributes(:winning => true) or raise RecordInvalid
      end
      self.update_attributes(:status => :closed) or raise RecordInvalid
    end
    true
  rescue RecordInvalid
    false
  end
  
  def reopen
    transaction do |txn|
      bids.all.update!(:winning => false) or raise RecordInvalid
      self.update_attributes(:status => :open) or raise RecordInvalid
    end
    true
  rescue RecordInvalid
    false
  end
  
end
