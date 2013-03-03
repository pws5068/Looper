class AddThumbUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :thumb_url, :string
  end
end
