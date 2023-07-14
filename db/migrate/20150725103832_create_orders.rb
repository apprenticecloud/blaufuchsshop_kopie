class CreateOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :orders do |t|
      t.references :customer, index: true
      t.string :state
      t.string :tracking_number
      t.date :shipping_date
      t.text :notes
      t.text :invoice_notes
      t.string :email
      t.string :given_name
      t.string :family_name
      t.text :extra_position
      t.decimal :extra_price
      t.references :school, index: true
      t.references :invoice_address, index: true
      t.references :school_address, index: true
      t.references :cart, index: true
      t.timestamps
    end
      add_foreign_key :orders, :carts
  end
end
