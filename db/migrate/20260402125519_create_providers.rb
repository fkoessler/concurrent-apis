class CreateProviders < ActiveRecord::Migration[8.1]
  def change
    create_table :providers do |t|
      t.string :name, null: false, index: { unique: true }
      t.timestamps
    end

    add_reference :search_results, :provider, index: true
  end
end
