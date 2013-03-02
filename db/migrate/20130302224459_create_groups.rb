class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :alias

      t.timestamps
    end
  end
end
