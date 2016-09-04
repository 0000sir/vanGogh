class CreateSubcribers < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribers do |t|
      t.boolean :subscribe
      t.string :openid
      t.string :nickname
      t.integer :sex
      t.string :language
      t.string :city
      t.string :province
      t.string :country
      t.string :headimgurl
      t.string :subscribe_time

      t.timestamps
    end
  end
end
