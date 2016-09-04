class ChangeStyleIdInArtworks < ActiveRecord::Migration[5.0]
  def change
    change_column :artworks, :style_id, :integer, :null=>true
  end
end
