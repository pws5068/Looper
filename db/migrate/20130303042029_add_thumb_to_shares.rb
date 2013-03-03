class AddThumbToShares < ActiveRecord::Migration
  def change
    add_column :shares, :thumb, :string
  end
end
