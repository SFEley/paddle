class Payments < Application
  provides :json

  def index(person_id)
    @person = Person.get(person_id)
    raise NotFound unless @person
    @payments = @person.payments
    display @payments
  end

  def show(id, person_id)
    @person = Person.get(person_id)
    raise NotFound unless @person
    @payment = @person.payments.get(id)
    raise NotFound unless @payment
    display @payment
  end

  def new
    only_provides :html
    @payment = Payment.new
    display @payment
  end

  def edit(id)
    only_provides :html
    @payment = Payment.get(id)
    raise NotFound unless @payment
    display @payment
  end

  def create(payment, person_id)
    @person = Person.get(person_id)
    @payment = @person.payments.build(payment)
    if @payment.save
      display @payment, :show
    else
      message[:error] = "Payment failed to be created"
      render :new
    end
  end

  def update(id, payment)
    @payment = Payment.get(id)
    raise NotFound unless @payment
    if @payment.update_attributes(payment)
       redirect resource(@payment)
    else
      display @payment, :edit
    end
  end

  def destroy(id, person_id)
    @person = Person.get(person_id)
    @payment = person.payments.get(id)
    raise NotFound unless @payment
    if @payment.destroy
      redirect resource(:payments)
    else
      raise InternalServerError
    end
  end

end # Payments
