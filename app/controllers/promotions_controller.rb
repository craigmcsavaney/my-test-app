class PromotionsController < ApplicationController
    def new
  		@promotion = Promotion.new
    end

  	def create
		@promotion = Promotion.new(params[:promotion])
	    if @promotion.save
	      # Handle a successful save.
	      flash[:success] = "New Promotion has been created"
	      redirect_to new_promotion_path
	    else
	      render 'new'
	    end  
	end

end
