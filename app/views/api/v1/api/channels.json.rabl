object @promotion

node do |promotion|
	if promotion.channels.where("name = ? and active = ?", 'Facebook', true).exists?
 	{:facebook => partial("api/v1/api/facebook", :object => promotion) }
 	end
end

node do |promotion|
	if promotion.channels.where("name = ? and active = ?", 'Twitter', true).exists?
 	{:twitter => partial("api/v1/api/twitter", :object => promotion) }
 	end
end

node do |promotion|
	if promotion.channels.where("name = ? and active = ?", 'Pinterest', true).exists?
 	{:pinterest => partial("api/v1/api/pinterest", :object => promotion) }
 	end
end

node do |promotion|
	if promotion.channels.where("name = ? and active = ?", 'Linkedin', true).exists?
 	{:linkedin => partial("api/v1/api/linkedin", :object => promotion) }
 	end
end

node do |promotion|
	if promotion.channels.where("name = ? and active = ?", 'GooglePlus', true).exists?
 	{:googleplus => partial("api/v1/api/googleplus", :object => promotion) }
 	end
end

#node do |promotion|
#	if promotion.channels.where("name = ? and active = ?", 'Email', true).exists?
# 	{:email => partial("api/v1/api/email", :object => promotion) }
# 	end
#end