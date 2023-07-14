class Admin::OrdersController < AdminController

  skip_before_action :only_admins
  before_action :admins_and_printery

  before_action :load_order, only: [:edit, :show, :update, :destroy, :deactivate, :activate]

  def index
    @orders = Order.all

    if params.has_key?(:search) && params[:search].has_key?(:value) && params[:search][:value].present?
      search_query = "%#{params[:search][:value]}%".downcase

      @orders = @orders.joins(:school).joins(:invoice_address).joins(:school_address).where(
        'orders.id::text LIKE :search_query'\
        ' OR LOWER(orders.state) LIKE :search_query'\
        ' OR LOWER(orders.given_name) LIKE :search_query'\
        ' OR LOWER(orders.family_name) LIKE :search_query'\
        ' OR LOWER(schools.name) LIKE :search_query'\
        ' OR LOWER(addresses.street_address) LIKE :search_query'\
        ' OR LOWER(addresses.postal_code) LIKE :search_query'\
        ' OR LOWER(addresses.address_locality) LIKE :search_query'\
        ' OR LOWER(school_addresses_orders.street_address) LIKE :search_query'\
        ' OR LOWER(school_addresses_orders.postal_code) LIKE :search_query'\
        ' OR LOWER(school_addresses_orders.address_locality) LIKE :search_query',
        {search_query: search_query}
      )
    end

    if params.has_key?(:order)
      params[:order].each do |key, value|
        if value[:column] == '1'
          @orders = @orders.order(state: value[:dir].to_sym)
        elsif value[:column] == '2'
          @orders = @orders.order(id: value[:dir].to_sym, given_name: value[:dir].to_sym, family_name: value[:dir].to_sym)
        elsif value[:column] == '4'
          @orders = @orders.order(created_at: value[:dir].to_sym)
        elsif value[:column] == '5'
          if value[:dir].to_sym == :asc
            @orders = @orders.joins(:school).order("schools.name ASC")
          else
            @orders = @orders.joins(:school).order("schools.name DESC")
          end
        end
      end
    end

    if params.has_key?(:length)
      @orders = @orders.limit(params[:length]).offset(params[:start])
    else
      @orders = @orders.limit(25)
    end

    @orders_total_count = Order.count
    @orders_display_count = @orders_total_count

    respond_to do |format|
      format.html
      format.json { render partial: 'admin/orders/orders' }
    end
  end

  def show
    if @order
      respond_to do |format|
        format.pdf do
          pdf = InvoicePdf.new(@order)
          send_data pdf.render,
            filename: 'Rechnung.pdf',
            type: 'application/pdf',
            disposition: 'inline' # attachment | inline to show directly
        end
      end
    else
      redirect_to admin_orders_path
    end
  end

  def batch
    action_type = params[:action_type]

    if action_type == 'export'
      batch_export
    elsif action_type == 'state'
      batch_state
    else
      redirect_to admin_orders_path
    end
  end

  def edit
    @invoice_address = @order.build_invoice_address if @order.invoice_address_id.nil?
    @school_address = @order.build_school_address if @order.school_address.nil?
    @order.cart.positions.build
  end

  def update
    previous_state = @order.state

    if @order.update(order_params)
      if @order.state != previous_state && @order.state == 'shipped'
        notify_the_user_that_his_order_is_shipped(@order)
      end
      if @order.state != previous_state && @order.state == 'stopped'
        notify_the_admin_that_a_order_is_stopped(@order)
      end
    end

    respond_with :edit, :admin, @order
  end

  # def destroy
  #   @order.destroy
  #   respond_with :admin, @order
  # end

  def deactivate
    # order = Order.find(params[:id])
    @order.deactivate!

    redirect_to admin_orders_path
  end

  def activate
    # order = Order.find(params[:id])
    @order.activate!

    redirect_to admin_orders_path
  end

  def export_prepare
    orders = load_ready_to_ship_orders(params[:weight_type], 0)
    file_info_pdf = orders_to_file(orders, 'pdf')
    file_info_csv = orders_to_file(orders, 'csv')

    update_orders_file_state(orders)

    begin
      # Send e-mails with file attachments
      AdminMailer.export_user(
        current_user.email,
        file_info_pdf,
        file_info_csv
      ).deliver_now

      AdminMailer.site_admin(
        file_info_pdf,
        file_info_csv
      ).deliver_now
    rescue Exception
    end

    exported_orders = 0
    if orders
      exported_orders = orders.count
    end

    respond_to do |format|
      format.json { render json: { exported_orders: exported_orders } }
    end
  end

  def export_finish
    orders = load_ready_to_ship_orders(params[:weight_type], 1)
    update_orders_to_shipped(orders)

    redirect_to admin_orders_path
  end

  def export
    orders = load_ready_to_ship_orders(params[:weight_type], 1)
    file_info = orders_to_file(orders, params[:export_type])

    send_file_or_redirect(file_info)
  end

private
  def order_params
    params.require(:order).permit :tracking_number, :shipping_date, :email,
      :given_name, :family_name, :school_id, :recipient, :deliver_to_school, :state,
      :extra_price, :extra_position, :notes, :invoice_notes,
      invoice_address_attributes: [:id, :address_locality, :street_address, :postal_code],
      school_address_attributes: [:id, :address_locality, :street_address, :postal_code],
      cart_attributes: [:id, positions_attributes: [:id, :amount, :product_variant_id, :_destroy]]
  end

  def load_order
    @order = Order.find_by id: params[:id]
  end

  def notify_the_user_that_his_order_is_shipped(order)
    begin
      NotificationMailer.shipped(order).deliver_now
    rescue Exception

    end
  end
  def notify_the_admin_that_a_order_is_stopped(order)
    begin
      NotificationMailer.stop(order).deliver_now
    rescue Exception

    end
  end

  def load_selected_orders
    if params[:order_ids]
      Order.where(id: params[:order_ids])
    else
      nil
    end
  end

  def load_ready_to_ship_orders(weight_type, file_state)
    if weight_type == 'low'
      Order.where(state: 'ready_to_ship', file_state: file_state).select{|order| order.weight < Constant.buechersendung}
    elsif weight_type == 'high'
      Order.where(state: 'ready_to_ship', file_state: file_state).select{|order| order.weight >= Constant.buechersendung}
    else
      nil
    end
  end

  def orders_to_file(orders, data_type)
    response = {}

    if orders.presence
      if data_type == 'pdf'
        pdf = InvoicePdf.new(orders)
        response[:file_data] = pdf.render
        response[:file_name] = 'Rechnungen.pdf'
        response[:file_type] = 'application/pdf'
      elsif data_type == 'csv'
        response[:file_data] = "\uFEFF" + Order.to_csv(orders)
        response[:file_name] = 'Rechnungen.csv'
        response[:file_type] = 'application/csv'
      end
    end

    response
  end

  def update_orders_file_state(orders)
    if orders.presence
      orders.each do |order|
        order.update(file_state: :exported)
      end
    end
  end

  def update_orders_to_shipped(orders)
    if orders.presence
      orders.each do |order|
        previous_state = order.state

        if order.update(state: 'shipped')
          if order.state != previous_state
            notify_the_user_that_his_order_is_shipped(order)
          end
        end

      end
    end
  end

  def send_file_or_redirect(file_info)
    if file_info.has_key?(:file_data) and file_info.has_key?(:file_name) and file_info.has_key?(:file_type)
      send_data(
        file_info[:file_data],
        filename: file_info[:file_name],
        type: file_info[:file_type],
        disposition: 'inline' # attachment | inline to show directly
      )
    else
      redirect_to admin_orders_path
    end
  end

  def batch_export
    orders = load_selected_orders

    data_type = params[:export_data_type].to_s.downcase || ''
    file_info = orders_to_file(orders, data_type)

    send_file_or_redirect(file_info)
  end

  def batch_state
    orders = load_selected_orders
    new_state = params[:new_state]

    if orders
      orders.each do |order|
        previous_state = order.state

        if order.update(state: new_state)
          if order.state != previous_state and order.state == 'shipped'
            notify_the_user_that_his_order_is_shipped(order)
          end
        end
      end
    end

    redirect_to admin_orders_path
  end
end
