class CreateArtworks < ActiveRecord::Migration[5.0]
  def change
    create_table :artworks do |t|
      t.attachment :source
      t.string :source_fingerprint
      t.string :openid
      t.integer :style_id
      t.attachment :output

      t.timestamps
    end
  end
end
