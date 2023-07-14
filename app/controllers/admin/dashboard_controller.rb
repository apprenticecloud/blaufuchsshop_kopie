class Admin::DashboardController < AdminController

  skip_before_action :only_admins
  before_action :admins_and_printery

  def dashboard
    @orders = Order.all
    @customers = Customer.all
    @products = Product.all
    @schools = School.all
  end

end
