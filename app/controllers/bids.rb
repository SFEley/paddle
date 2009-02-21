class Bids < Application
  provides :json

  def index(auction_id)
    @auction = Auction.get(auction_id)
    @bids = @auction.bids
    display @bids
  end

  def show(id, auction_id)
    @auction = Auction.get(auction_id)
    @bid = @auction.bids.get(id)
    raise NotFound unless @bid
    display @bid
  end

  def new
    only_provides :html
    @bid = Bid.new
    display @bid
  end

  def edit(id)
    only_provides :html
    @bid = Bid.get(id)
    raise NotFound unless @bid
    display @bid
  end

  def create(bid, auction_id)
    @auction = Auction.get(auction_id)
    @bid = @auction.bids.build(bid)
    if @bid.save
      display @bid, :show
    else
      message[:error] = "Bid failed to be created"
      render :new
    end
  end

  def update(id, bid)
    @bid = Bid.get(id)
    raise NotFound unless @bid
    if @bid.update_attributes(bid)
       redirect resource(@bid)
    else
      display @bid, :edit
    end
  end

  def destroy(id, auction_id)
    @auction = Auction.get(auction_id)
    @bid = @auction.bids.get(id)
    raise NotFound unless @bid
    if @bid.destroy
      {:reply => "Bid deleted!"}.to_json
    else
      raise InternalServerError
    end
  end

end # Bids
