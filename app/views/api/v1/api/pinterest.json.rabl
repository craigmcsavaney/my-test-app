object @promotion

node do |promotion|
 { :details => partial("api/v1/api/pinterest_share_details", :object => promotion) }
end