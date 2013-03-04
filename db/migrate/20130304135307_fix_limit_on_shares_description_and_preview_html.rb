class FixLimitOnSharesDescriptionAndPreviewHtml < ActiveRecord::Migration
  def up
    remove_column :shares, :description
    remove_column :shares, :preview_html
    add_column :shares, :description, :text
    add_column :shares, :preview_html, :text
  end

  def down
    remove_column :shares, :description
    remove_column :shares, :preview_html
    add_column :shares, :description, :string
    add_column :shares, :preview_html, :string
  end
end
