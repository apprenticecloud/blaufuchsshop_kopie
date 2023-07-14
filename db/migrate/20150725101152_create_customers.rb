class CreateCustomers < ActiveRecord::Migration[4.2]
  def change
    create_table :customers do |t|
      t.references :user, index: true
      t.string :given_name
      t.string :family_name
      t.references :school, index: true
      t.string :telephone
      t.string :role
      t.references :address, index: true
      t.references :cart, index: true
      t.timestamps
    end
    add_foreign_key :customers, :users
    add_foreign_key :customers, :schools
    add_foreign_key :customers, :carts
  end
end
