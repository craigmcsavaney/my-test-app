class Setting < ActiveRecord::Base
	include NotDeleteable
	versioned

  	attr_accessible :p_banner_1, :facebook_default_msg, :facebook_link_label, :facebook_caption, :banner_template_1, :banner_template_2, :banner_template_3, :banner_template_4, :banner_template_5, :banner_template_6, :banner_template_7, :banner_template_8

end
