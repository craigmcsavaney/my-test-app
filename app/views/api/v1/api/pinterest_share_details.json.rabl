object @promotion

attributes :pinterest_msg => :msg
attributes :pin_image_url => :image_url
attributes :pin_def_board => :def_board
attributes :pin_thumb_url => :thumb_url

node :url_prefix do |promotion|
	Channel.find_by_name("Pinterest").url_prefix
end