object @promotion

node do |promotion|
 { :channel_details => partial("api/v1/api/twitter_share_details", :object => promotion) }
end