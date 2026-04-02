class CreateSearchResults < ActiveRecord::Migration[8.1]
  def change
    create_table :search_results do |t|
      t.belongs_to :search
      t.jsonb :data, default: {}, null: false
      t.timestamps
    end

    add_index :search_results, :data, using: :gin
  end
end
