object @promotion

node do |promotion|
 { :details => partial("api/v1/api/twitter_share_details", :object => promotion) }
end