require "prawn/layout"

class People < Application
  provides :json, :pdf

  def index
    if params[:q]
      @people = Person.all(:conditions => ["paddle = ? OR first_name like ? OR last_name like ?", params[:q].to_i, params[:q] + '%', params[:q] + '%']).by_names
    else
      @people = Person.by_names
    end
    case content_type
    when :pdf
      people = @people
      Prawn::Document.generate "/tmp/people.pdf" do
        people.each do |person|
          font "Helvetica"
          font_size 22
          text "#{person.common_name}"
          if person.selling && person.selling.bids(:winning => true)
            font_size 14
            text "Items Sold:"
            font_size 9
            sold = []
            person.selling.each do |auction|
              auction.bids(:winning => true).each do |bid|
                sold << [auction.code || '', auction.title || '', bid.buyer.common_name || '', bid.buyer.phone || '', bid.buyer.email || '', bid.amount.to_currency || '']
              end
            end
            sold << [' ', ' ', ' ', ' ', ' ', ' '] if sold.empty?
            
            table sold,
              :position => :left,
              :border_style => :underline_header,
              :headers => ['Code', 'Title', 'Bidder', 'Phone', 'Email', 'Amount'],
              :row_colors => :pdf_writer
          end
          text ""
          text ""
          
          if person.bids(:winning => true)
            font_size 14
            text "Items Bought:"
            font_size 12
            text "Total: #{person.total_purchases.to_currency}"
            font_size 9
            bought = []
            person.bids(:winning => true).each do |bid|
              bought << [bid.auction.code || '', bid.auction.title || '', bid.auction.description || '', (bid.auction.seller && bid.auction.seller.common_name) || '', (bid.auction.seller && bid.auction.seller.phone) || '', (bid.auction.seller && bid.auction.seller.email) || '', bid.amount.to_currency || '']
            end
            bought << [' ', ' ', ' ', ' ', ' ', ' ', ' '] if bought.empty?
            
            table bought,
              :position => :left,
              :border_style => :underline_header,
              :headers => ['Code', 'Title', 'Description', 'Seller', 'Phone', 'Email', 'Amount'],
              :row_colors => :pdf_writer
          end

          start_new_page
        end
      end
      send_file("/tmp/people.pdf")
    else
      display @people
    end
  end

  def show(id)
    @person = Person.get(id)
    raise NotFound unless @person
    case content_type
    when :pdf
      person = @person
      Prawn::Document.generate "/tmp/person.pdf" do
        font "Helvetica"
        font_size 22
        text "#{person.common_name}"
        if person.selling && person.selling.bids(:winning => true)
          font_size 18
          text "Items Sold:"
          font_size 12
          sold = []
          person.selling.each do |auction|
            auction.bids(:winning => true).each do |bid|
              sold << [auction.code || '', auction.title || '', bid.buyer.common_name || '', bid.buyer.phone || '', bid.buyer.email || '', bid.amount.to_currency || '']
            end
          end
          sold << [' ', ' ', ' ', ' ', ' ', ' '] if sold.empty?
        
          table sold,
            :position => :left,
            :border_style => :underline_header,
            :headers => ['Code', 'Title', 'Bidder', 'Phone', 'Email', 'Amount'],
            :row_colors => :pdf_writer
        end
      
        if person.bids(:winning => true)
          font_size 18
          text "Items Bought:"
          font_size 14
          text "Total: #{person.total_purchases.to_currency}"
          font_size 12
          bought = []
          person.bids(:winning => true).each do |bid|
            bought << [bid.auction.code || '', bid.auction.title || '', bid.auction.description || '', (bid.auction.seller && bid.auction.seller.common_name) || '', (bid.auction.seller && bid.auction.seller.phone) || '', (bid.auction.seller && bid.auction.seller.email) || '', bid.amount.to_currency || '']
          end
          bought << [' ', ' ', ' ', ' ', ' ', ' ', ' '] if bought.empty?
        
          table bought,
            :position => :left,
            :border_style => :underline_header,
            :headers => ['Code', 'Title', 'Description', 'Seller', 'Phone', 'Email', 'Amount'],
            :row_colors => :pdf_writer
        end
      end
      send_file("/tmp/person.pdf")
    else
      display @person
    end
  end

  def new
    only_provides :html
    @person = Person.new
    display @person
  end

  def edit(id)
    only_provides :html
    @person = Person.get(id)
    raise NotFound unless @person
    display @person
  end

  def create(person)
    @person = Person.new(person)
    if @person.save
      redirect resource(@person), :message => {:notice => "Person was successfully created."}
    else
      message[:error] = "Could not create person."
      render :new
    end
  end

  def update(id, person)
    @person = Person.get(id)
    raise NotFound unless @person
    if @person.update_attributes(person)
       redirect resource(@person), :message => {:notice => "Person was successfully updated."}
    else
      message[:error] = "Could not update person."
      render :edit
    end
  end

  def destroy(id)
    @person = Person.get(id)
    raise NotFound unless @person
    if @person.destroy
      redirect resource(:people)
    else
      raise InternalServerError
    end
  end

private
  def pdf_report(filename)
    Prawn::Document.generate "/tmp/" + filename do
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
end # People
