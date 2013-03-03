class RenameSharesTypeToMediaType < ActiveRecord::Migration
  def change
    rename_column :shares, :type, :media_type
  end
end
