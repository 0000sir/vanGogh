class WechatsController < ApplicationController
  # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#rails-responder-controller-dsl
  wechat_responder

  on :text do |request, content|
    request.reply.text "发一张照片给我，就能帮你用大师的风格画出来" # Just echo
  end
  
  on :text, with: /^(\d+)$/ do |request, content|
    begin
      style = Style.find content.to_i
      last = Artwork.where(:openid=>request[:FromUserName]).last
      unless last.nil?
        last.style_id = style.id
        last.save
      end
      request.reply.text "将为你模仿#{style.author}的#{style.title}风格来画这幅画"
    rescue
      request.reply.text "没有这个风格吧"
    end
  end
  
  on :event, with: 'subscribe' do |request|
    info = wechat.user request[:FromUserName]
    Subscriber.create(:subscribe=>true, :openid=>info['openid'], :nickname=>info['nickname'], :sex=>info['sex'],
                :language=>info['language'], :city=>info['city'], :country=>info['country'], :province=>info['province'],
                :headimgurl=>info['headimgurl'], :subscribe_time=>info['subscribe_time']) unless info.nil?
    request.reply.text "欢迎#{info['nickname']}，发一张照片给我，就能帮你用大师的风格画出来"
  end
  
  on :image do |request|
    # 0. check artwork that style not set
    msg = ""
    if Artwork.where(:openid=>request[:FromUserName], :style_id=>nil).count >0
      msg = "上一张照片还没有选择绘画风格，请先设置\n"
      media_id = Artwork.where(:openid=>request[:FromUserName], :style_id=>nil).last.media_id
      wechat_msg = {:touser=>request[:FromUserName], :msgtype=>"image", :image=>{:media_id=>media_id}}
      wechat.custom_message_send wechat_msg
    else
      # 1. fetch image from wechat server
      file = wechat.media request[:MediaId]
      # 2. save it to local
      Artwork.create :source=>File.new(file.path), :openid=>request[:FromUserName], :media_id=>request[:MediaId]
    end
    artists = ""
    Style.all.each do |style|
      artists += "#{style.id}. #{style.author}\n"
    end
    msg +=  "请选择艺术家风格:\n#{artists}直接回复数字选择"
    request.reply.text msg
  end
  
  on :shortvideo do |request|
    request.reply.text "视频太贪心了哦，发个照片吧" # Echo the sent image to user
  end
  
  on :video do |request|
    request.reply.text "视频太贪心了哦，发个照片吧" # Echo the sent image to user
  end
  
  on :voice do |request|
    request.reply.text "声音现在还画不出来[糗大了]" # Echo the sent image to user
  end
end
