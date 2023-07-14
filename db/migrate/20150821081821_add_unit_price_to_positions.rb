class AddUnitPriceToPositions < ActiveRecord::Migration[4.2]
  def change
    add_column :positions, :unit_price, :decimal
  end
end
