class AddPreviewHtmlToShares < ActiveRecord::Migration
  def change
    add_column :shares, :preview_html, :string
  end
end
