class CreateSpatis < ActiveRecord::Migration[7.1]
  def change
    create_table :spatis do |t|
      t.string :name
      t.string :address
      t.string :opening_time
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
