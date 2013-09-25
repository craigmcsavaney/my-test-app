object @promotion

node do |promotion|
 { :channel_details => partial("api/v1/api/email_share_details", :object => promotion) }
end