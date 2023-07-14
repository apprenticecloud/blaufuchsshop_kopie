class CreateProductSubjectSelections < ActiveRecord::Migration[4.2]
  def change
    create_table :product_subject_selections do |t|
      t.references :product, index: true
      t.references :subject, index: true
    end
    add_foreign_key :product_subject_selections, :products
    add_foreign_key :product_subject_selections, :subjects
  end
end
