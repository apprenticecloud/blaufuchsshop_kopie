class AddFileStateToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :file_state, :integer, default: 0
  end
end
