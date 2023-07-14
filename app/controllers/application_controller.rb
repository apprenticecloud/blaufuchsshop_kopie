require "application_responder"

class ApplicationController < ActionController::Base

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

#  before_action :only_active_users

  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_customer
    current_user.customer if current_user
  end

  def set_cart
    @cart = get_cart || create_new_cart

    rescue Exception => e
      @cart = create_new_cart
  end

  def get_cart
    if current_customer
      cart = current_customer.cart || retrieve_cart_from_session
    else
      cart = retrieve_cart_from_session
    end

    return cart
  end

  def retrieve_cart_from_session
    cart_id = session[:cart_id]
    if cart_id
      cart = Cart.find_by(id: cart_id.to_i)
    end

    if cart && current_customer
      session[:cart_id] = nil
      cart.customer = current_customer
      cart.save
      cart
    elsif cart
      cart
    else
      nil
    end
  end

  def create_new_cart
    if current_customer
      cart = current_customer.create_cart
    else
      cart = Cart.create
      session[:cart_id] = cart.id
    end

    return cart
  end

private

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || (((current_user.role == 'admin') || (current_user.role == 'printery')) ? :admin : :root)
  end


protected

  def configure_devise_permitted_parameters
    registration_params = [:role, :email, :password, :password_confirmation,
                            customer_attributes: [:id, :school_id]]

    if params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up, keys: registration_params.reject { |key, value| key == 'role' && !['teacher', 'student'].include?(value) })
    elsif params[:action] == 'update'
      devise_parameter_sanitizer.permit(:account_update, keys: registration_params << :current_password)
    end
  end

end
