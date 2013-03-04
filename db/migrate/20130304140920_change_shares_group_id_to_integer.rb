class ChangeSharesGroupIdToInteger < ActiveRecord::Migration
  def up
    change_column :shares, :group_id, :integer, :limit => nil
  end

  def down
    change_column :shares, :group_id, :string
  end
end
