
json.iTotalRecords @orders_total_count
json.iTotalDisplayRecords @orders_display_count

json.data(@orders) do |order|
    json.id json_order_id(order)
    json.state json_order_state(order)
    json.customer json_order_customer(order)
    json.address json_order_address(order)
    json.created_at json_order_created_at(order)
    json.school_name json_order_school_name(order)
    json.buttons json_order_buttons(order)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
json.iTotalRecords @orders_total_count
json.iTotalDisplayRecords @orders_display_count

json.data(@orders) do |order|
    json.id json_order_id(order)
    json.state json_order_state(order)
    json.customer json_order_customer(order)
    json.address json_order_address(order)
    json.created_at json_order_created_at(order)
    json.school_name json_order_school_name(order)
    json.buttons json_order_buttons(order)
end
