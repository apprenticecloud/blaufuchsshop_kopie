class AddDeliverToSchoolToOrder < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :deliver_to_school, :boolean, default: false
  end
end
