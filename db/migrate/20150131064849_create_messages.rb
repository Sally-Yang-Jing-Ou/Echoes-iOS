class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :body
      t.decimal :latitude
      t.decimal :longitude
      t.integer :radius
      t.text :file

      t.timestamps null: false
    end
  end
end
