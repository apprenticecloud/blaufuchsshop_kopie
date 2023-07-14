class AddTelephoneToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :telephone, :string
  end
end
