object @promotion
attributes :name, :id, :banner
attributes :cause_id => :default_cause
#attributes :fb_msg, :fb_link_label, :fb_caption, :fb_redirect_url, :fb_thumb_url, if: lambda { |m| m.channel_ids.include?(Channel.find_by_name('Facebook').id) } 

node :cause_selector do |promotion|
	if promotion.supporter_pct > 0 or promotion.buyer_pct > 0
	true
	else
	false
	end
end

node do |promotion|
	if promotion.channel_ids.include?(Channel.find_by_name('Facebook').id)
 	{:facebook => partial("api/facebook", :object => promotion) }
 	end
end


#child :channels => :new_name do
#  attributes :name, :id
#end