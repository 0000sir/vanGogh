class Style < ApplicationRecord
  has_attached_file :image, styles: {thumbnail: "120x120>", medium: "512x512>", large: "1024x1024>"}
  validates_attachment_content_type :image, content_type: /\Aimage/
  
  has_many :artworks
  
end
