class CreateStyles < ActiveRecord::Migration[5.0]
  def change
    create_table :styles do |t|
      t.string :title
      t.string :author
      t.attachment :image
      t.string :image_fingerprint

      t.timestamps
    end
  end
end
