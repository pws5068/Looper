class ConvertSharesDescriptionToText < ActiveRecord::Migration
  def up
    change_column :shares, :description, :text
  end

  def down
    change_column :shares, :description, :string
  end
end
