object @serve

#attributes :email

node do |serve|
	if !serve.user.nil?
		{ :email => serve.user.email }
	end
end

node :current_cause_id do |serve|
	serve.cause.uid
end	

node do |serve|
 { :paths => partial("api/v1/api/share_links", :object => serve) }
end