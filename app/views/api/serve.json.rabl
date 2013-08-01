object @serve
attributes :id => :serve_id
attributes :email, :cause_id, :share_id

child :shares do #|serve|
	attributes :link_id, :channel_id,  if: lambda { |m| m.channel_id == Channel.find_by_name('Purchase').id } 
end

node :promotion do |serve|
	serve.promotion
end

node :merchant_share do |serve|
	if serve.promotion.merchant_pct > 0
	true
	else
	false
	end
end

node :promoter_share do |serve|
	if serve.promotion.supporter_pct > 0
	true
	else
	false
	end
end

node :buyer_share do |serve|
	if serve.promotion.buyer_pct > 0
	true
	else
	false
	end
end


node :merchant do |serve|
	serve.promotion.merchant
end

#node do |serve|
#	@channels = serve.promotion.channel_ids
#	node :channels do |channels|
#		Channel.find(channels).name
#	end
#end



#node :channels do |channels|
#	serve.promotion.channel_ids do |channel_id|
#		Channel.find(channel_id).name
#	end
#end

#node :promotion_name do |serve|
#	Promotion.find(serve.promotion_id)
#end

node :promotion2 do |serve|
 { :promotion => partial("promotions/show", :object => serve.promotion) }
end

node :channels do |serve|
 { :channels => partial("api/channels", :object => serve.promotion.channels) }
end

node :elem_id do 
		"cbw-share-msg"
end

node :default do 
		"default-msg"
end

node :def_type do 
		"reference"
end

node :maps_to do 
		"description"
end