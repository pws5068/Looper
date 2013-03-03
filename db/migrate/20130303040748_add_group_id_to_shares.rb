class AddGroupIdToShares < ActiveRecord::Migration
  def change
    add_column :shares, :group_id, :string
  end
end
