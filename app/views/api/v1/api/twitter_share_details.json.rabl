object @promotion

attributes :twitter_msg => :msg

node :url_prefix do |promotion|
	Channel.find_by_name("Twitter").url_prefix
end