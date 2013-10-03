object @promotion

attributes :facebook_msg => :msg
attributes :fb_link_label => :link_label
attributes :fb_caption => :caption
attributes :fb_redirect_url => :redirect_url
attributes :fb_thumb_url => :thumb_url

node :url_prefix do |promotion|
	Channel.find_by_name("Facebook").url_prefix
end
