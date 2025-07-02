class CreateMarkets < ActiveRecord::Migration[8.0]
  def change
    create_table :markets do |t|
      t.string :name
      t.string :location
      t.string :district

      t.timestamps
    end
  end
end
