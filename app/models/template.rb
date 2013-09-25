class Template < ActiveRecord::Base

  	def self.get_banner_template(promotion)
  		# 0 or nil = false, non-zero = true
  		a = !(promotion.merchant_pct == 0 or promotion.merchant_pct == nil)
  		b = !(promotion.supporter_pct == 0 or promotion.supporter_pct == nil)
  		c = !(promotion.buyer_pct == 0 or promotion.buyer_pct == nil)

  		percents = [a,b,c]
  		case percents
  			# merchant,supporter,buyer: 0,0,0
	  		when [false,false,false]
	  			banner_template = Setting.first.banner_template_1

  			# merchant,supporter,buyer: 0,0,>0
	  		when [false,false,true]
	  			banner_template = Setting.first.banner_template_2

  			# merchant,supporter,buyer: 0,>0,0
	  		when [false,true,false]
	  			banner_template = Setting.first.banner_template_3

  			# merchant,supporter,buyer: 0,>0,>0
	  		when [false,true,true]
	  			banner_template = Setting.first.banner_template_4

  			# merchant,supporter,buyer: >0,0,0
	  		when [true,false,false]
	  			banner_template = Setting.first.banner_template_5

  			# merchant,supporter,buyer: >0,0,>0
	  		when [true,false,true]
	  			banner_template = Setting.first.banner_template_6

  			# merchant,supporter,buyer: >0,>0,0
	  		when [true,true,false]
	  			banner_template = Setting.first.banner_template_7

  			# merchant,supporter,buyer: >0,>0,>0
	  		when [true,true,true]
	  			banner_template = Setting.first.banner_template_8

  		end
  		return banner_template

  	end

    def self.get_facebook_msg_template(promotion)
      # 0 or nil = false, non-zero = true
      a = !(promotion.merchant_pct == 0 or promotion.merchant_pct == nil)
      b = !(promotion.supporter_pct == 0 or promotion.supporter_pct == nil)
      c = !(promotion.buyer_pct == 0 or promotion.buyer_pct == nil)

      percents = [a,b,c]
      case percents
        # merchant,supporter,buyer: 0,0,0
        when [false,false,false]
          facebook_msg_template = Setting.first.fb_msg_template_1

        # merchant,supporter,buyer: 0,0,>0
        when [false,false,true]
          facebook_msg_template = Setting.first.fb_msg_template_2

        # merchant,supporter,buyer: 0,>0,0
        when [false,true,false]
          facebook_msg_template = Setting.first.fb_msg_template_3

        # merchant,supporter,buyer: 0,>0,>0
        when [false,true,true]
          facebook_msg_template = Setting.first.fb_msg_template_4

        # merchant,supporter,buyer: >0,0,0
        when [true,false,false]
          facebook_msg_template = Setting.first.fb_msg_template_5

        # merchant,supporter,buyer: >0,0,>0
        when [true,false,true]
          facebook_msg_template = Setting.first.fb_msg_template_6

        # merchant,supporter,buyer: >0,>0,0
        when [true,true,false]
          facebook_msg_template = Setting.first.fb_msg_template_7

        # merchant,supporter,buyer: >0,>0,>0
        when [true,true,true]
          facebook_msg_template = Setting.first.fb_msg_template_8
      end
      return facebook_msg_template

    end

    def self.replace_template_variables(message,promotion)

      if message.include? "{{merchant}}"
        message = message.gsub(/\{\{merchant\}\}/, promotion.merchant.name)
      end

      if message.include? "{{merchant_pct}}"
        message = message.gsub(/\{\{merchant_pct\}\}/, promotion.merchant_pct.to_s)
      end

      if message.include? "{{merchant_cause}}" and promotion.cause != nil
        message = message.gsub(/\{\{merchant_cause\}\}/, promotion.cause.name)
      end

      if message.include? "{{supporter_pct}}"
        message = message.gsub(/\{\{supporter_pct\}\}/, promotion.supporter_pct.to_s)
      end

      if message.include? "{{buyer_pct}}"
        message = message.gsub(/\{\{buyer_pct\}\}/, promotion.buyer_pct.to_s)
      end

      return message
    end

end
