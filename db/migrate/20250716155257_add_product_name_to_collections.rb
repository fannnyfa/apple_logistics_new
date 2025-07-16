class AddProductNameToCollections < ActiveRecord::Migration[8.0]
  def change
    add_column :collections, :product_name, :string, default: "사과"
  end
end
