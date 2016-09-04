class AddMediaIdToArtworks < ActiveRecord::Migration[5.0]
  def change
    add_column :artworks, :media_id, :string
  end
end
