object @promotion

node do |promotion|
	if promotion.channel_ids.include?(Channel.find_by_name('Facebook').id)
 	{:facebook => partial("api/v1/api/facebook", :object => promotion) }
 	end
end

node do |promotion|
	if promotion.channel_ids.include?(Channel.find_by_name('Twitter').id)
 	{:twitter => partial("api/v1/api/twitter", :object => promotion) }
 	end
end

node do |promotion|
	if promotion.channel_ids.include?(Channel.find_by_name('Pinterest').id)
 	{:pinterest => partial("api/v1/api/pinterest", :object => promotion) }
 	end
end

node do |promotion|
	if promotion.channel_ids.include?(Channel.find_by_name('Linkedin').id)
 	{:linkedin => partial("api/v1/api/linkedin", :object => promotion) }
 	end
end

#node do |promotion|
#	if promotion.channel_ids.include?(Channel.find_by_name('Email').id)
# 	{:email => partial("api/v1/api/email", :object => promotion) }
# 	end
#end