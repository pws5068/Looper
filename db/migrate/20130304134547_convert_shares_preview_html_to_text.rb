class ConvertSharesPreviewHtmlToText < ActiveRecord::Migration
  def up
    change_column :shares, :preview_html, :text
  end

  def down
    change_column :shares, :preview_html, :string
  end
end
