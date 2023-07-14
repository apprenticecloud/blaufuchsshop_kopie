class AddDeactivatedAtToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :deactivated_at, :datetime
  end
end
