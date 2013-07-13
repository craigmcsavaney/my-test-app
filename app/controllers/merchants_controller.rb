class MerchantsController < ApplicationController
  load_and_authorize_resource

  def create
    params[:merchant][:user_ids] ||= []
		@merchant = Merchant.new(params[:merchant])
    if @merchant.save
      user=current_user
      @merchant.users << user
      # Handle a successful save.
      flash[:success] = "New Merchant has been created"
      redirect_to merchants_url
    else
      render 'new'
    end  
	end

  def create_admin
    params[:merchant][:user_ids] ||= []
    @merchant = Merchant.new(params[:merchant])
    if @merchant.save
      # Handle a successful save.
      flash[:success] = "New Merchant has been created"
      redirect_to merchants_admin_url
    else
      render 'new_admin'
    end  
  end

  def new_admin
		@merchant = Merchant.new
  end

  def new
    @merchant = Merchant.new
    
  end

  def edit
  	@merchant = Merchant.find(params[:id])
  end

  def edit_admin
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

  def update_admin
    @merchant = Merchant.find(params[:id])
    if @merchant.update_attributes(params[:merchant])
      # Handle a successful update.
      flash[:success] = "Merchant updated"
      redirect_to merchants_admin_url
    else
      render 'edit_admin'
    end
  end

  def index
    @user = current_user
  	@merchants = @user.merchants.paginate(page: params[:page])
  end

  def index_admin
    @merchants = Merchant.paginate(page: params[:page])
  end

  def destroy
    Merchant.find(params[:id]).destroy
    flash[:success] = "Merchant deleted"
    redirect_to merchants_url
	end
end
