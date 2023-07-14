module Admin::OrdersHelper
  def json_order_id(order)
    render partial: "admin/orders/json/id", locals: { order: order }
  end

  def json_order_state(order)
    render partial: "admin/orders/json/state", locals: { order: order }
  end

  def json_order_customer(order)
    render partial: "admin/orders/json/customer", locals: { order: order }
  end

  def json_order_address(order)
    render partial: "admin/orders/json/address", locals: { order: order }
  end

  def json_order_created_at(order)
    render partial: "admin/orders/json/created_at", locals: { order: order }
  end

  def json_order_school_name(order)
    render partial: "admin/orders/json/school_name", locals: { order: order }
  end

  def json_order_buttons(order)
    render partial: "admin/orders/json/buttons", locals: { order: order }
  end
end
