object @promotion

node do |promotion|
 { :channel_details => partial("api/v1/api/facebook_share_details", :object => promotion) }
end

node do |promotion|
	if !promotion.disable_msg_editing?
		{ :user_fields => partial("api/v1/api/user_fields", :object => promotion) }
	end
end

