object @promotion

node do |promotion|
 { :details => partial("api/v1/api/googleplus_share_details", :object => promotion) }
end
