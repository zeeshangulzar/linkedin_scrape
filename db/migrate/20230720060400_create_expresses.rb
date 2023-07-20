class CreateExpresses < ActiveRecord::Migration[7.0]
  def change
    create_table :expresses do |t|

      t.timestamps
    end
  end
end
