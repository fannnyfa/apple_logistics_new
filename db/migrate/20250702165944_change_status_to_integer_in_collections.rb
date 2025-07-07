class ChangeStatusToIntegerInCollections < ActiveRecord::Migration[8.0]
  def up
    # First, set default values for existing records
    execute "UPDATE collections SET status = '1' WHERE status IS NULL OR status = ''"
    
    # Change column type to integer
    change_column :collections, :status, :integer, default: 1, null: false
  end
  
  def down
    change_column :collections, :status, :string
  end
end
