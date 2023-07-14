class Admin::CustomersController < AdminController

  def index
    @customers = Customer.all
  end

  def destroy
    @customer = Customer.find_by id: params[:id]
    user = @customer.user
    @customer.destroy
    user.destroy

    flash[:alert] = @customer.errors.full_messages.join(', ') if @customer.persisted?

    redirect_to admin_customers_path
  end

  def deactivate
    customer = Customer.find(params[:id])
    customer.user.deactivate!

    redirect_to admin_customers_path
  end

  def activate
    customer = Customer.find(params[:id])
    customer.user.activate!

    redirect_to admin_customers_path
  end

private
  def customer_params
    params.require(:customer).permit
  end

end
