class CreateUserThings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_things do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
