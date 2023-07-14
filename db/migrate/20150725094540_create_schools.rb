class CreateSchools < ActiveRecord::Migration[4.2]
  def change
    create_table :schools do |t|
      t.string :name
      t.references :address, index: true
    end
  end
end
