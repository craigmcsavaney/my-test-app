object @promotion

node do |promotion|
 { :channel_details => partial("api/twitter_share_details", :object => promotion) }
end