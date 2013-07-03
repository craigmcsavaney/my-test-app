class MerchantsController < ApplicationController
  	def create
		@merchant = Merchant.new(params[:merchant])
	    if @merchant.save
	      # Handle a successful save.
	      flash[:success] = "New Merchant has been created"
	      redirect_to new_merchant_path
	    else
	      render 'new'
	    end  
	end

    def new
  		@merchant = Merchant.new
    end

    def update
    end
end
