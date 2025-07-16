class AddWeightToCollections < ActiveRecord::Migration[8.0]
  def change
    add_column :collections, :weight, :string, default: "10kg"
  end
end
