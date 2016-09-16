class Artwork < ApplicationRecord
  has_attached_file :source, styles: {thumbnail: "120x120#", medium: "512x>", large: "1024x1024>"}
  has_attached_file :output, styles: {thumbnail: "120x120#", medium: "512x>", large: "1024x1024>"}
  has_attached_file :decorated_output
  validates_attachment_content_type :source, content_type: /\Aimage/
  validates_attachment_content_type :output, content_type: /\Aimage/
  validates_attachment_content_type :decorated, content_type: /\Aimage/
  before_post_process :rename_file_to_mime_type
  belongs_to :style, required: false
  
  EXTENSIONS = {"image/jpeg"=>".jpg", "image/png"=>".png"}
  
  APPRENTICES = ["http://0000:123456@192.168.30.85:3000/artworks.json"]
  
  # call remote Artist
  def convert!
    require 'rest_client'
    RestClient.post(random_apprentice, 
            "artwork[source_file]"=>File.new(self.source.path(:medium)),
            "artwork[style][fingerprint]"=>self.style.image_fingerprint,
            "artwork[style][source]"=>"http://dev.gonghui.org.cn#{self.style.image.url(:large)}",
            "artwork[callback]"=>"http://0000:123456@dev.gonghui.org.cn/artworks/callback.json") unless self.style_id.nil?
  end
  
  def sendfile
    # 1. upload to wechat
    response = Wechat.api.media_create "image", "#{self.decorated_output.path(:large)}"
    media_id = response['media_id']
    # 2. send to client
    wechat_msg = {:touser=>self.openid, :msgtype=>"image", :image=>{:media_id=>media_id}}
    Wechat.api.custom_message_send wechat_msg
  end
  
  def decorate!
    require 'rmagick'
    #include Magick
    sign = Magick::Image.read("#{Rails.root}/public/sign.jpg").first
    image = Magick::Image.read(self.output.path(:medium)).first
    image_w = image.columns
    image_h = image.rows
    frame = Magick::Image.new(image_w+28, image_h+114){self.background_color="white"}
    pixels = image.get_pixels(0,0,image_w,image_h)
    sign_pixels = sign.get_pixels(0,0,sign.columns,sign.rows)
    frame.store_pixels(14,14,image_w,image_h,pixels)
    frame.store_pixels(0, image_h+28, sign.columns,sign.rows, sign_pixels)
    #frame.write("#{Rails.root}/public/aa.jpg")
    tmp_file = "/tmp/artwork_#{self.id}.jpg"
    File.delete(tmp_file) if File.exist?(tmp_file)
    frame.write tmp_file
    self.decorated_output = File.new(tmp_file)
    self.save
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
