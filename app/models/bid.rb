class Bid
  include DataMapper::Resource
  
  property :id, Serial
  property :amount, BigDecimal, :precision => 6, :scale => 2, :default => 0
  property :winning, Boolean
  
  belongs_to :buyer, :class_name => "Person", :child_key => [:buyer_id]
  belongs_to :auction

end
