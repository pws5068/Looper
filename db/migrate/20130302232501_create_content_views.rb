class CreateContentViews < ActiveRecord::Migration
  def change
    create_table :content_views do |t|
      t.integer :content_id
      t.integer :user_id

      t.timestamps
    end
  end
end
