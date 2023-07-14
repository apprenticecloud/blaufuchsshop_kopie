class CreateAddresses < ActiveRecord::Migration[4.2]
  def change
    create_table :addresses do |t|
      t.string :street_address
      t.string :postal_code
      t.string :address_locality
    end
  end
end
