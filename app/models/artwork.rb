class Artwork < ApplicationRecord
  has_attached_file :source, styles: {thumbnail: "120x120#", medium: "512x512>", large: "1024x1024>"}
  has_attached_file :output, styles: {thumbnail: "120x120#", medium: "512x512>", large: "1024x1024>"}
  validates_attachment_content_type :source, content_type: /\Aimage/
  validates_attachment_content_type :output, content_type: /\Aimage/
  
  belongs_to :style, required: false
  
  after_save :convert
  
  # call remote Artist
  def convert
    require 'rest_client'
    
    RestClient.post("http://192.168.30.85:3000/artworks.json", 
            "artwork[source_file]"=>File.new(self.source.path), "artwork[style_file]"=>File.new(self.style.image.path))
  end
  
  
end
