class CreateProducts < ActiveRecord::Migration[4.2]
  def change
    create_table :products do |t|
      t.string :title
      t.string :subtitle
      t.text :description
      t.decimal :price
      t.decimal :reduced_price
      t.string :year
      t.string :image
      t.decimal :weight
    end
  end
end
