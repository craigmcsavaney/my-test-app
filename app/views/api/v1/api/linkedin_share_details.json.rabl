object @promotion

attributes :linkedin_msg => :msg

node :url_prefix do |promotion|
	Channel.find_by_name("Linkedin").url_prefix
end