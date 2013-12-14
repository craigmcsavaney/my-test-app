object @serve

#attributes :email

node do |serve|
	if !serve.user.nil?
		{ :email => serve.user.email }
	else
		{ :email => "" }
	end
end

node do |serve|
	if serve.cause.type == 'Single'
		{ :cause_type => "single", 
		  :fg_uuid => serve.cause.fg_uuid, 
		  :event_uid => "",
		  :cause_name => serve.cause.name }
	else
		{ :cause_type => "event", 
		  :fg_uuid => "", 
		  :event_uid => serve.cause.event.uid,
		  :cause_name => serve.cause.name }
	end
end

#node :current_cause_id do |serve|
#	serve.cause.uid
#end	

node do |serve|
 { :paths => partial("api/v1/api/share_links", :object => serve) }
end