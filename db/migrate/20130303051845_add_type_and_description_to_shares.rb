class AddTypeAndDescriptionToShares < ActiveRecord::Migration
  def change
    add_column :shares, :type, :string
    add_column :shares, :description, :string
  end
end
