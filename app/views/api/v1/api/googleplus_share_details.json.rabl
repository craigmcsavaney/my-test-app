object @promotion

attributes :googleplus_msg => :msg

node :url_prefix do |promotion|
	Channel.find_by_name("GooglePlus").url_prefix
end