class CreateDarazs < ActiveRecord::Migration[7.0]
  def change
    create_table :darazs do |t|
      t.string :title
      t.text :body
      t.string :price
      t.text :images

      t.timestamps
    end
  end
end
