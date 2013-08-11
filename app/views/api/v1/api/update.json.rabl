object @serve

attributes :email, :current_cause_id

node do |serve|
 { :share_links => partial("api/v1/api/share_links", :object => serve) }
end