class Subscriber < ApplicationRecord
  has_many :artworks, :foreign_key=>'openid'
  
  def style_not_set
    Artwork.where :openid=>self.openid, :style_id=>nil
  end
end
