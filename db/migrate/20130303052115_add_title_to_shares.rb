class AddTitleToShares < ActiveRecord::Migration
  def change
    add_column :shares, :title, :string
  end
end
