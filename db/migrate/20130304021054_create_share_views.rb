class CreateShareViews < ActiveRecord::Migration
  def change
    create_table :share_views do |t|
      t.integer :user_id
      t.integer :share_id

      t.timestamps
    end
  end
end
