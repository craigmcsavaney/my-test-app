object @promotion

node do |promotion|
 { :channel_details => partial("api/linkedin_share_details", :object => promotion) }
end

