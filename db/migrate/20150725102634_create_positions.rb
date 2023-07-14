class CreatePositions < ActiveRecord::Migration[4.2]
  def change
    create_table :positions do |t|
      t.references :product_variant, index: true
      t.integer :amount
      t.integer :position
      t.references :cart, index: true
    end
    add_foreign_key :positions, :product_variants
    add_foreign_key :positions, :carts
  end
end
