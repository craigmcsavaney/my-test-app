class ApiController < ApplicationController
  def serve
    # accepts Merchant id as input
    merchant = Merchant.find(params[:merchant_id])
    # set date to today
    check_date = Date.today
    # Get merchant's current promotion
    @current = Current.get_current_promotion(check_date,merchant)
    if @current[:promotion] == nil
        # No current promotion found
        # need suitable api response here
        render 'error'
    else
        # Current promotion successfully identified
        @promotion = @current[:promotion]
        # Check to see if valid serve_id and share_id were passed in.
		serve_invalid = Serve.not_exists?(params[:serve_id])
		share_invalid = Share.not_exists?(params[:share_id])
        # Now, based on the presence of valid serve_id and share_id, serve
        # the correct promotion, creating a new serve if necessary, and generate
        # a session id for this session.
		case
		# First case, when serve_id and share_id weren't passed in or don't match
		# existing records.  Typically, this is a first time, non-referred visitor 
		when serve_invalid && share_invalid
			# create a new serve using the current promotion
			@serve = Serve.create(promotion_id: @promotion.id)
			# need to create a session_id
		# Second case, when serve_id is invalid and share_id is valid.
		# Typically, this is a first time, referred visitor 
		when serve_invalid && !share_invalid
			# create a new serve using the current promotion and the share_id
			@serve = Serve.create(promotion_id: @promotion.id, share_id: params[:share_id])
			# need to create a session_id

		# Third case, when serve_id is valid and share_id is invalid.
		# Typically, this is a return visit from a non-referred visitor 
		when !serve_invalid && share_invalid
			@old = Serve.find(params[:serve_id])
			# Is the current promotion the same as the one from the serve_id?
    		if @old.promotion_id == @promotion.id
    			# Yes, the current promotion is the same as the serve_id promotion
    			@serve = Serve.find(params[:serve_id]) # reload the old serve
    		else
    			# No, the current promotion is different
    			# NOTE: the terms of the current promotion may preclude using the old
    			# cause.  Need a method to check the old cause and make sure to use it
    			# only if allowable by the current promotion.
    			@serve = Serve.create(promotion_id: @promotion.id, email: @old.email, cause_id: @old.cause_id)
    		end
			# need to create a session_id

		# Third case, when serve_id is valid and share_id is invalid.
		# Typically, this is a return visit from a non-referred visitor 
		else # !serve_invalid and !share_invalid	
			@old = Serve.find(params[:serve_id])
			# Is the current promotion the same as the one from the serve_id?
    		if @old.promotion_id == @promotion.id
    			# Yes, the current promotion is the same as the serve_id promotion
    			@serve = Serve.find(params[:serve_id]) # reload the old serve
    		else
    			# No, the current promotion is different
    			# NOTE: the terms of the current promotion may preclude using the old
    			# cause.  Need a method to check the old cause and make sure to use it
    			# only if allowable by the current promotion.
    			@serve = Serve.create(promotion_id: @promotion.id, email: @old.email, cause_id: @old.cause_id, share_id: @old.share_id)
    		end
			# need to create a session_id
		end
        render 'serve'
    end    
  end

  def email
  	# inputs: session_id, email, share_id, serve_id
  	# if session_id is blank, render error message
  	# add or update email
  	# do purchase_share
  	# render success message
  end
end