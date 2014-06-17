object @serve
attributes :id => :serve_id
attributes :session_id, :viewed, :created_at

node do |serve|
	if !serve.user.nil?
		{ :email => serve.email }
	else
		{ :email => "" }
	end
end

node do |serve|
	if Cause.find(serve.current_cause_id).type == 'Single'
		{ :cause_type => "single", 
		  :fg_uuid => Cause.find(serve.current_cause_id).fg_uuid, 
		  :event_uid => "",
		  :cause_uid => Cause.find(serve.current_cause_id).uid,
		  :cause_name => Cause.find(serve.current_cause_id).name }
	else
		{ :cause_type => "event", 
		  :fg_uuid => "", 
		  :event_uid => Cause.find(serve.current_cause_id).event.uid,
		  :cause_uid => Cause.find(serve.current_cause_id).event.uid,
		  :cause_name => Cause.find(serve.current_cause_id).event.name }
	end
end

node do |serve|
	if Cause.find(serve.default_cause_id).type == 'Single'
		{ :default_cause_type => "single", 
		  :default_fg_uuid => Cause.find(serve.default_cause_id).fg_uuid, 
		  :default_event_uid => "",
		  :default_cause_name => Cause.find(serve.default_cause_id).name,
		  :default_cause_uid => Cause.find(serve.default_cause_id).uid }
	else
		{ :default_cause_type => "event", 
		  :default_fg_uuid => "", 
		  :default_event_uid => Cause.find(serve.default_cause_id).event.uid,
		  :default_cause_name => Cause.find(serve.default_cause_id).event.name,
		  :default_cause_uid => Cause.find(serve.default_cause_id).event.uid }
	end
end

node :cookie_life do |serve|
	Setting.first.cookie_life
end

node do |serve|
 { :merchant => partial("api/v1/api/merchant", :object => serve.promotion.merchant) }
end

node do |serve|
 { :paths => partial("api/v1/api/share_links", :object => serve) }
end

node :display_order do |serve|
	serve.promotion.channels.where("active = ? and visible = ?", true, true).order('display_order').pluck(:name,:font_awesome_icon_name)
end

node do |serve|
 { :promotion => partial("api/v1/api/promotions", :object => serve.promotion) }
end

node do |serve|
 { :channels => partial("api/v1/api/channels", :object => serve.promotion) }
end

# Unused Stuff:

#node :promotion do |serve|
#	serve.promotion
#end

#node :merchant do |serve|
#	serve.promotion.merchant
#end

#node :channels do |channels|
#	serve.promotion.channel_ids do |channel_id|
#		Channel.find(channel_id).name
#	end
#end

#node :promotion_name do |serve|
#	Promotion.find(serve.promotion_id)
#end

#node :channels do |serve|
# { :channels => partial("api/channels", :object => serve.promotion.channels) }
#end

#node :merchant_name do |serve|
#	serve.promotion.merchant.name
#end

#node :merchant_id do |serve|
#	serve.promotion.merchant.id
#end

#child :shares  do 
#	attributes :link_id,  if: lambda { |m| m.channel_id == Channel.find_by_name('Purchase').id } 
#end

