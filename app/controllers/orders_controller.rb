class OrdersController < ApplicationController
  before_action :set_cart
  before_action :order_something_before_checkout

  def new
    # if the order was rejected on the confirm step the user can edit the data
    if session[:order_params]
      @order = build_order_from_session_data
    #  clear_order_session_data
    else
      @order = build_new_order
    end
  end

  def validate
    @order = Order.new(order_params)
    @order.cart = @cart
    @order.customer = current_customer

    if @order.valid?
      session[:order_params] = order_params
      update_cart_positions_unit_price
      redirect_to confim_order_path
    else
      session[:order_params] = order_params
      render :new
    end
  end

  def confirm
    @order = build_order_from_session_data

    redirect_to checkout_path, flash: { error: t('flash_messages.fill_your_order_details') } unless @order.valid?
  end

  def create
    @order = build_order_from_session_data

    if @order.save
      clear_order_session_data
      update_user_profile(@order) if current_customer
      set_new_cart
      update_customer_cart_attributes(@order)
      send_user_email_with_order_datails(@order)

      render 'thanks'
    else
      redirect_to checkout_path, flash: { error: t('flash_messages.fill_your_order_details') }
    end

  end

  def checkout_save
    @cart.update_attributes(checkout_save_params)

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

    def order_params
      params.require(:order).permit(:given_name, :family_name, :email, :telephone, :notes, :school_id,
                                    :terms_and_conditions_accepted, :return_policy_read, :recipient, :notes, :deliver_to_school,
                                    invoice_address_attributes: [:street_address, :postal_code, :address_locality])
    end

    def checkout_save_params
      params.permit(
        :given_name,
        :family_name,
        :street_address,
        :address_locality,
        :postal_code,
        :email,
        :telephone,
        :school,
        :recipient,
        :notes
      )
    end

    def order_something_before_checkout
      redirect_to edit_cart_path, flash: { error: t('flash_messages.order_something_before_checkout') } unless @cart.something_was_ordered?
    end

    def update_user_profile(order)
      current_customer.attributes = order.slice('given_name',
                                                  'family_name',
                                                  'school_id',
                                                  'telephone',
                                                  'cart_id')

      current_user.email = order.email

      current_customer.build_address unless current_customer.address.presence
      current_customer.address.attributes = order.invoice_address.attributes.slice('street_address',
                                                                                    'postal_code',
                                                                                    'address_locality')
      current_user.save
      current_customer.save

      # create new cart - use the old one to keep track what is ordered
      current_customer.create_cart
    end

    def set_new_cart
      if current_customer
        current_customer.create_cart
      else
        cart = Cart.create
        session[:cart_id] = cart.id
      end
    end

    def update_customer_cart_attributes(order)
      if current_customer
        current_customer.cart.attributes = order.cart.attributes.slice(
          'given_name',
          'family_name',
          'street_address',
          'address_locality',
          'postal_code',
          'email',
          'telephone',
          'school',
          'recipient',
          'notes',
        )
      end
    end

    def build_order_from_session_data
      order = Order.new

      begin
       order = Order.new(session[:order_params])
      rescue Exception
        clear_order_session_data
      end

      order.customer = current_customer
      order.cart = @cart

      order
    end

    def clear_order_session_data
      session[:order_params] = nil
    end

    def build_new_order
      order = Order.new
      order.build_invoice_address

      # if the user is logged in prefill the order fields
      if current_customer
        order.attributes = current_customer.attributes.slice('given_name',
                                                              'family_name',
                                                              'school_id',
                                                              'telephone',
                                                              'cart_id')
        if current_customer.address
          order.invoice_address.attributes = current_customer.address.attributes.slice('street_address',
                                                                                        'postal_code',
                                                                                        'address_locality')
        end

        order.email = current_user.email
      end

      set_new_order_attributes_from_cart(order, @cart)

      order.customer = current_customer
      order.cart = @cart
      order
    end

    def set_new_order_attributes_from_cart(order, cart)
      order.given_name = cart.given_name || order.given_name
      order.family_name = cart.family_name || order.family_name
      order.school = School.find_by(name: cart.school) || order.school
      order.telephone = cart.telephone || order.telephone
      order.email = cart.email || order.email
      order.notes = cart.notes || order.notes
      order.recipient = cart.recipient || order.recipient

      order.invoice_address.street_address = cart.street_address || order.invoice_address.street_address
      order.invoice_address.address_locality = cart.address_locality || order.invoice_address.address_locality
      order.invoice_address.postal_code = cart.postal_code || order.invoice_address.postal_code
    end

    def send_user_email_with_order_datails(order)
      begin
        NotificationMailer.new_order(order).deliver_now
      rescue Exception
        # log the exception
      end
    end

    def update_cart_positions_unit_price
      @cart.positions.each{ |position| position.update_unit_price(@cart.charge_reduced_prices?) }
    end
end
