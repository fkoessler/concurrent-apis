class CreateSearches < ActiveRecord::Migration[8.1]
  def change
    create_table :searches do |t|
      t.string :origin, null: false
      t.string :destination, null: false
      t.date :date, null: false
      t.timestamps
    end
  end
end
