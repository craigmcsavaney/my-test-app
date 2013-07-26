class Banner < ActiveRecord::Base

  	def self.get_banner(promotion)
  		# 0 or nil = false, non-zero = true
  		a = !(promotion.merchant_pct == 0 or promotion.merchant_pct == nil)
  		b = !(promotion.supporter_pct == 0 or promotion.supporter_pct == nil)
  		c = !(promotion.buyer_pct == 0 or promotion.buyer_pct == nil)
  		
  		percents = [a,b,c]
  		case percents
  			# merchant,supporter,buyer: 0,0,0
	  		when [false,false,false]
	  			banner = Setting.first.banner_template_1

  			# merchant,supporter,buyer: 0,0,>0
	  		when [false,false,true]
	  			banner = Setting.first.banner_template_2

  			# merchant,supporter,buyer: 0,>0,0
	  		when [false,true,false]
	  			banner = Setting.first.banner_template_3

  			# merchant,supporter,buyer: 0,>0,>0
	  		when [false,true,true]
	  			banner = Setting.first.banner_template_4

  			# merchant,supporter,buyer: >0,0,0
	  		when [true,false,false]
	  			banner = Setting.first.banner_template_5

  			# merchant,supporter,buyer: >0,0,>0
	  		when [true,false,true]
	  			banner = Setting.first.banner_template_6

  			# merchant,supporter,buyer: >0,>0,0
	  		when [true,true,false]
	  			banner = Setting.first.banner_template_7

  			# merchant,supporter,buyer: >0,>0,>0
	  		when [true,true,true]
	  			banner = Setting.first.banner_template_8
  		end

  		if banner.include? "_merchant_name_"
  			banner = banner.gsub(/_merchant_name_/, promotion.merchant.name)
  		end

  		if banner.include? "_merchant_pct_"
	  		banner = banner.gsub(/_merchant_pct_/, promotion.merchant_pct.to_s)
  		end

  		if banner.include? "_supporter_pct_"
	  		banner = banner.gsub(/_supporter_pct_/, promotion.supporter_pct.to_s)
  		end

  		if banner.include? "_buyer_pct_"
	  		banner = banner.gsub(/_buyer_pct_/, promotion.buyer_pct.to_s)
  		end

  		if banner.include? "_cause_"
	  		banner = banner.gsub(/_cause_/, promotion.cause.name)
  		end

  		return banner

  	end

end
