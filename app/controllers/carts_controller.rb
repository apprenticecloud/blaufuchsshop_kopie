class CartsController < ApplicationController
  before_action :set_cart, only: [:edit, :update]

  def edit
    @teacher = teacher?
    @admin = admin?
    @products = Product.all.order(title: :asc)
  end

  def update
    location = params[:proceed_to_checkout] == '1' ? '/checkout' : edit_cart_path

    @cart.update(cart_params)

    respond_with :edit, @cart, location: location
  end

private

  def teacher?
    current_customer && current_user.role == 'teacher'
  end

  def admin?
    current_user && current_user.role == 'admin'
  end

  def cart_params
    params.require(:cart).permit positions_attributes: [:id, :amount, :product_variant_id]
  end
end