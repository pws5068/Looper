class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :url

      t.timestamps
    end
  end
end
