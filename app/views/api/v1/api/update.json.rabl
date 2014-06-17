object @serve

#attributes :email

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
 { :paths => partial("api/v1/api/share_links", :object => serve) }
end