class Payment
  include DataMapper::Resource
  
  property :id, Serial
  property :type, String
  property :amount, BigDecimal, :precision => 6, :scale => 2, :default => 0, :nullable => false

  belongs_to :person

  validates_present :person_id
  
end
