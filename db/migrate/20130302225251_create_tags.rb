class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :content_id
      t.string :keyword

      t.timestamps
    end
  end
end
