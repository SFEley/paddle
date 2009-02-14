class Auctions < Application
  # provides :xml, :yaml, :js

  def index
    @auctions = Auction.all
    display @auctions
  end

  def show(id)
    @auction = Auction.get(id)
    raise NotFound unless @auction
    display @auction
  end

  def new
    only_provides :html
    @auction = Auction.new
    display @auction
  end

  def edit(id)
    only_provides :html
    @auction = Auction.get(id)
    raise NotFound unless @auction
    display @auction
  end

  def create(auction)
    @auction = Auction.new(auction)
    if @auction.save
      redirect resource(@auction), :message => {:notice => "Auction was successfully created"}
    else
      message[:error] = "Auction failed to be created"
      render :new
    end
  end

  def update(id, auction)
    @auction = Auction.get(id)
    raise NotFound unless @auction
    if @auction.update_attributes(auction)
       redirect resource(@auction)
    else
      display @auction, :edit
    end
  end

  def destroy(id)
    @auction = Auction.get(id)
    raise NotFound unless @auction
    if @auction.destroy
      redirect resource(:auctions)
    else
      raise InternalServerError
    end
  end

end # Auctions
