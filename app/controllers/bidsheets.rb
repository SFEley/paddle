require "prawn/layout"


class Bidsheets < Application
  provides :pdf
  
  def index
    
    auctions = Auction.all(:auction_type => "Silent")
    Prawn::Document.generate "/tmp/bidsheets.pdf" do
      auctions.each do |auction|
        font "Helvetica"
        font_size 18
        text "#{auction.code}     #{auction.title}"
        font_size 12
        text "#{auction.description}"
        text " "
        text "Seller: #{auction.seller.common_name if auction.seller}"
        text "How many: #{auction.quantity}"
        text "Opening bid: #{auction.minimum_bid.to_currency}"
      
        font_size 16
        data = []
        20.times {|i| data << [" ", " "]}
      
        table data,
          :position => :left,
          :border_style => :grid,
          :headers => ["#       ", "Bid amount                                     "],
          :column_widths => {0 => 100, 1 => 400}
          
        start_new_page
      end
      
    end
      
    send_file("/tmp/bidsheets.pdf")
  end
  
end
