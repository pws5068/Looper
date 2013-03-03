class CreateShareViews < ActiveRecord::Migration
  def change
    create_table :share_views do |t|

      t.timestamps
    end
  end
end
