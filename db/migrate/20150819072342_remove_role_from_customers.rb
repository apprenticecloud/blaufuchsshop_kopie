class RemoveRoleFromCustomers < ActiveRecord::Migration[4.2]
  def change
    remove_column :customers, :role, :string
  end
end
