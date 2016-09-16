class AddDecoratedToArtworks < ActiveRecord::Migration[5.0]
  def change
    add_attachment :artworks, :decorated_output
  end
end
