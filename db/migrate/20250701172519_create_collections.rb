class CreateCollections < ActiveRecord::Migration[8.0]
  def change
    create_table :collections do |t|
      t.string :farm_name
      t.integer :quantity
      t.references :market, null: false, foreign_key: true
      t.string :receiver
      t.datetime :scheduled_at
      t.string :status

      t.timestamps
    end
  end
end
