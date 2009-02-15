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
  property :status, Enum[:open, :closed], :default => :open
  
  validates_within :auction_type, :set => TYPES
  validates_is_number :quantity
  validates_is_number :minimum_bid
  

end
