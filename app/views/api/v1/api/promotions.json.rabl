object @promotion
attributes :name, :id, :banner, :landing_page

node :button_html do |promotion|
	promotion.button.html
end

node :widget_position do |promotion|
	promotion.widget_position.name
end

node :cause_selector do |promotion|
	if promotion.supporter_pct > 0 or promotion.buyer_pct > 0
	true
	else
	false
	end
end

node do |promotion|
	if promotion.cause.type == 'Single'
		{ :default_cause_type => "single", 
		  :default_fg_uuid => promotion.cause.fg_uuid, 
		  :default_event_uid => "" }
	else
		{ :default_cause_type => "event", 
		  :default_fg_uuid => "", 
		  :default_event_uid => promotion.cause.event.uid }
	end
end


#attributes :fb_msg, :fb_link_label, :fb_caption, :fb_redirect_url, :fb_thumb_url, if: lambda { |m| m.channel_ids.include?(Channel.find_by_name('Facebook').id) } 

#node do |promotion|
#	if promotion.channel_ids.include?(Channel.find_by_name('Facebook').id)
# 	{:facebook => partial("api/v1/api/facebook", :object => promotion) }
# 	end
#end

#node do |promotion|
#	if promotion.channel_ids.include?(Channel.find_by_name('Twitter').id)
# 	{:twitter => partial("api/v1/api/twitter", :object => promotion) }
# 	end
#end

#node do |promotion|
#	if promotion.channel_ids.include?(Channel.find_by_name('Pinterest').id)
# 	{:pinterest => partial("api/v1/api/pinterest", :object => promotion) }
# 	end
#end

#node do |promotion|
#	if promotion.channel_ids.include?(Channel.find_by_name('Linkedin').id)
# 	{:linkedin => partial("api/v1/api/linkedin", :object => promotion) }
# 	end
#end

#node do |promotion|
#	if promotion.channel_ids.include?(Channel.find_by_name('Email').id)
# 	{:email => partial("api/v1/api/email", :object => promotion) }
# 	end
#end

#child :channels => :new_name do
#  attributes :name, :id
#end