class CreateAmazons < ActiveRecord::Migration[7.0]
  def change
    create_table :amazons do |t|
      t.string :title
      t.string :price
      t.text :image
      t.timestamps
    end
  end
end
