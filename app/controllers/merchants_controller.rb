class MerchantsController < ApplicationController
  	def create
		@merchant = Merchant.new(params[:merchant])
	    if @merchant.save
	      # Handle a successful save.
	      flash[:success] = "New Merchant has been created"
	      redirect_to merchants_url
	    else
	      render 'new'
	    end  
	end

    def new
  		@merchant = Merchant.new
    end

    def edit
    	@merchant = Merchant.find(params[:id])
    end

    def update
    	@merchant = Merchant.find(params[:id])
    	if @merchant.update_attributes(params[:merchant])
      		# Handle a successful update.
	      	flash[:success] = "Merchant updated"
      		redirect_to merchants_url
		else
  			render 'edit'
  		end
	end

    def index
    	@merchants = Merchant.paginate(page: params[:page])
    end

    def destroy
	    Merchant.find(params[:id]).destroy
	    flash[:success] = "Merchant deleted"
	    redirect_to merchants_url
	end
end
