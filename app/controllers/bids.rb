class Bids < Application
  # provides :xml, :yaml, :js

  def index
    @bids = Bid.all
    display @bids
  end

  def show(id)
    @bid = Bid.get(id)
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

  def create(bid)
    @bid = Bid.new(bid)
    if @bid.save
      redirect resource(@bid), :message => {:notice => "Bid was successfully created"}
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

  def destroy(id)
    @bid = Bid.get(id)
    raise NotFound unless @bid
    if @bid.destroy
      redirect resource(:bids)
    else
      raise InternalServerError
    end
  end

end # Bids
