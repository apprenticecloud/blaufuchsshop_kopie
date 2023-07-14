class CreateProductVariants < ActiveRecord::Migration[4.2]
  def change
    create_table :product_variants do |t|
      t.references :product, index: true
      t.boolean :teacher_edition
    end
    add_foreign_key :product_variants, :products
  end
end