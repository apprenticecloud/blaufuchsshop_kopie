class AddRecipientToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :recipient, :string
  end
end
