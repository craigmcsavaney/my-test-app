class Setting < ActiveRecord::Base
	include NotDeleteable
	versioned

  	attr_accessible :banner, :fb_link_label, :fb_caption, :fb_redirect_url, :fb_thumb_url, :banner_template_1, :banner_template_2, :banner_template_3, :banner_template_4, :banner_template_5, :banner_template_6, :banner_template_7, :banner_template_8, :fb_msg_1, :fb_msg_2, :fb_msg_3, :fb_msg_4, :fb_msg_5, :fb_msg_6, :fb_msg_7, :fb_msg_8, :tw_msg, :pin_msg, :pin_image_url, :pin_def_board, :pin_thumb_url, :li_msg, :cookie_life

  	validates :cookie_life, numericality: { only_integer: true, greater_than: 0 }

end
