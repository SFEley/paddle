class People < Application
  provides :json

  def index
    if params[:q]
      @people = Person.all(:conditions => ["paddle = ? OR first_name like ? OR last_name like ?", params[:q].to_i, params[:q] + '%', params[:q] + '%']).by_names
    else
      @people = Person.by_names
    end
    display @people
  end

  def show(id)
    @person = Person.get(id)
    raise NotFound unless @person
    display @person
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

end # People
