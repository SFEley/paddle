class Import < Application

  def import
    parser = FasterCSV.new(params[:import][:tempfile],
      :headers => true,
      :header_converters => :symbol
    )
    
    parser.convert do |field, info|
      case info.header
        when :minimum_bid
          field.to_f
        when :quantity
          field.to_i
        when :person_name
          /^(.*)\s+(\w+)$/.match(field).to_a
        else
          field
      end
    end
    
    count = 0
    errors = 0
    parser.each do |row|
      a = Auction.first(:code => row[0]) || Auction.new(:code => row[0])
      a.quantity = row[1]
      a.title = row[2]
      a.description = row[3]
      a.minimum_bid = row[4]
      a.auction_type = row[7]
      
      p = Person.first(:first_name => row[5][1], :last_name => row[5][2]) || Person.new(:first_name => row[5][1], :last_name => row[5][2])
      p.phone = row[6]
      p.save
      
      a.seller_id = p.id
      if a.save
        count = count + 1
      else
        errors = errors + 1
      end
    end
    
    if errors > 0                  
      redirect resource(:auctions), :message => {:warning => "#{count} rows were imported; #{errors} rows had errors." }
    else
      redirect resource(:auctions), :messsage => {:notice => "#{count} rows were imported."}
    end
  end
  
end
