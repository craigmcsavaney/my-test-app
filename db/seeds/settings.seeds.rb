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
      banner_template_2: "Make a purchase and we'll donate {{buyer_pct}}% of the total to the cause of your choice!", 
      banner_template_3: "Share with your friends and we'll donate {{supporter_pct}}% to the cause of your choice!", 
      banner_template_4: "Share with your friends and we'll donate {{supporter_pct}}% to the cause of your choice!", 
      banner_template_5: "Share with your friends and we'll donate {{merchant_pct}}% of sales to the {{merchant_cause}}!", 
      banner_template_6: "Make a purchase and we'll donate {{buyer_pct}}% of the total to the cause of your choice, plus we'll donate an additional {{merchant_pct}}% to the {{merchant_cause}}!", 
      banner_template_7: "Share with your friends and we'll donate {{supporter_pct}}% to the cause of your choice, plus we'll donate an additional {{merchant_pct}}% to the {{merchant_cause}}!", 
      banner_template_8: "Share with your friends and we'll donate {{supporter_pct}}% to the cause of your choice, plus we'll donate an additional {{merchant_pct}}% to the {{merchant_cause}}!", 
      fb_link_label: "The Caption", 
      fb_caption: "Click Me",
      fb_redirect_url: "http://www.example.com",
      fb_thumb_url: "http://www.example.com",
      fb_msg_template_1: "fb msg template 1",
      fb_msg_template_2: "fb msg template 2",
      fb_msg_template_3: "fb msg template 3",
      fb_msg_template_4: "fb msg template 4",
      fb_msg_template_5: "fb msg template 5",
      fb_msg_template_6: "fb msg template 6",
      fb_msg_template_7: "fb msg template 7",
      fb_msg_template_8: "fb msg template 8",
      twitter_msg_template: "twitter sample message template",
      pinterest_msg_template: "pinterest sample message template",
      pin_image_url:"http://www.example.com",
      pin_def_board:"pinterest default board",
      pin_thumb_url:"http://www.example.com",
      linkedin_msg_template: "linkedin sample message template",
      cookie_life: "30",
      email_subject_template: "email sample subject template",
      email_body_template: "email sample body template",
      googleplus_msg_template: "googleplus sample message template"   
      )
      puts 'All seed Settings found or created'
   else
      puts 'Setting record already existed - no new settings created'

   end

                 
