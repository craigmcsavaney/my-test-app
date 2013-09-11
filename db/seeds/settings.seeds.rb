# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Preparing to create seed Settings'

   if Setting.count == 0
     Setting.create(
      banner_template_1: "There are no non-zero contribution percentages - this is currently an invalid promotion and should never happen.", 
      banner_template_2: "Make a purchase and we'll donate _buyer_pct_% of the total to the cause of your choice!", 
      banner_template_3: "Share with your friends and we'll donate _supporter_pct_% to the cause of your choice!", 
      banner_template_4: "Share with your friends and we'll donate _supporter_pct_% to the cause of your choice!", 
      banner_template_5: "Share with your friends and we'll donate _merchant_pct_% of sales to the _cause_!", 
      banner_template_6: "Make a purchase and we'll donate _buyer_pct_% of the total to the cause of your choice, plus we'll donate an additional _merchant_pct_% to the _cause_!", 
      banner_template_7: "Share with your friends and we'll donate _supporter_pct_% to the cause of your choice, plus we'll donate an additional _merchant_pct_% to the _cause_!", 
      banner_template_8: "Share with your friends and we'll donate _supporter_pct_% to the cause of your choice, plus we'll donate an additional _merchant_pct_% to the _cause_!", 
      fb_link_label: "The Caption", 
      fb_caption: "Click Me",
      fb_redirect_url: "http://www.example.com",
      fb_thumb_url: "http://www.example.com",
      fb_msg_1: "fb msg template 1",
      fb_msg_2: "fb msg template 2",
      fb_msg_3: "fb msg template 3",
      fb_msg_4: "fb msg template 4",
      fb_msg_5: "fb msg template 5",
      fb_msg_6: "fb msg template 6",
      fb_msg_7: "fb msg template 7",
      fb_msg_8: "fb msg template 8",
      tw_msg: "twitter sample message",
      pin_msg: "pinterest sample message",
      pin_image_url:"http://www.example.com",
      pin_def_board:"pinterest default board",
      pin_thumb_url:"http://www.example.com",
      li_msg: "linkedin sample message",
      cookie_life: "30"   
      )
      puts 'All seed Settings found or created'
   else
      puts 'Setting record already existed - no new settings created'

   end

                 
