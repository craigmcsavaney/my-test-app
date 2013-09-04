object @serve

attributes :email

node :current_cause_id do |serve|
	serve.cause.uid
end	

node do |serve|
 { :share_links => partial("api/v1/api/share_links", :object => serve) }
end