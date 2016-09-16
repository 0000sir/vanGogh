class Artwork < ApplicationRecord
  has_attached_file :source, styles: {thumbnail: "120x120#", medium: "512x512>", large: "1024x1024>"}
  has_attached_file :output, styles: {thumbnail: "120x120#", medium: "512x512>", large: "1024x1024>"}
  validates_attachment_content_type :source, content_type: /\Aimage/
  validates_attachment_content_type :output, content_type: /\Aimage/
  before_post_process :rename_file_to_mime_type
  belongs_to :style, required: false
  
  EXTENSIONS = {"image/jpeg"=>".jpg", "image/png"=>".png"}
  
  APPRENTICES = ["http://0000:123456@192.168.30.85:3000/artworks.json"]
  
  # call remote Artist
  def convert!
    require 'rest_client'
    RestClient.post(random_apprentice, 
            "artwork[source_file]"=>File.new(self.source.path),
            "artwork[style][fingerprint]"=>self.style.image_fingerprint,
            "artwork[style][source]"=>"http://dev.gonghui.org.cn#{self.style.image.url}",
            "artwork[callback]"=>"http://0000:123456@dev.gonghui.org.cn/artworks.json") unless self.style_id.nil?
  end
  
  def sendfile
    # 1. upload to wechat
    response = Wechat.api.media_create "image", "#{self.output.path(:large)}"
    media_id = response['media_id']
    # 2. send to client
    wechat_msg = {:touser=>self.openid, :msgtype=>"image", :image=>{:media_id=>media_id}}
    Wechat.api.custom_message_send wechat_msg
  end
  
  private
    def rename_file_to_mime_type
      extension = EXTENSIONS[source_content_type]
      self.source.instance_write :file_name, "#{source_file_name}#{extension}"
    end
    
    def random_apprentice
      APPRENTICES.shuffle.first
    end
  
end
