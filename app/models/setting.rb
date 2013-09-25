class Setting < ActiveRecord::Base
	include NotDeleteable
	versioned

  	attr_accessible :banner, :fb_link_label, :fb_caption, :fb_redirect_url, :fb_thumb_url, :banner_template_1, :banner_template_2, :banner_template_3, :banner_template_4, :banner_template_5, :banner_template_6, :banner_template_7, :banner_template_8, :fb_msg_template_1, :fb_msg_template_2, :fb_msg_template_3, :fb_msg_template_4, :fb_msg_template_5, :fb_msg_template_6, :fb_msg_template_7, :fb_msg_template_8, :twitter_msg_template, :pinterest_msg_template, :pin_image_url, :pin_def_board, :pin_thumb_url, :linkedin_msg_template, :cookie_life, :deleted, :email_subject_template, :email_body_template, :googleplus_msg_template

  	validates :cookie_life, numericality: { only_integer: true, greater_than: 0 }

end
