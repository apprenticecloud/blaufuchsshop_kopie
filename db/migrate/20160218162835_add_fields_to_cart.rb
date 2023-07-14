class AddFieldsToCart < ActiveRecord::Migration[4.2]
  def change
    add_column :carts, :given_name, :string
    add_column :carts, :family_name, :string
    add_column :carts, :street_address, :string
    add_column :carts, :address_locality, :string
    add_column :carts, :postal_code, :string
    add_column :carts, :email, :string
    add_column :carts, :telephone, :string
    add_column :carts, :school, :string
    add_column :carts, :recipient, :string
    add_column :carts, :notes, :text
  end
end
