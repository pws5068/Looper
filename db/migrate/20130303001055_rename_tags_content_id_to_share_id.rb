class RenameTagsContentIdToShareId < ActiveRecord::Migration
  def up
    rename_column :tags, :content_id, :share_id
  end

  def down
  end
end
