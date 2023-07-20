class CreateExpresses < ActiveRecord::Migration[7.0]
  def change
    create_table :expresses do |t|
      t.string :title
      t.string :price
      t.text :image
      t.timestamps
    end
  end
end
