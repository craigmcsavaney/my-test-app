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
    @merchant.updated_by = current_user
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
    @merchant.updated_by = current_user
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
  	@merchants = @user.merchants.order('id asc').paginate(page: params[:page])
  end

  def index_admin
    @merchants = Merchant.order('id asc').paginate(page: params[:page])
  end

  def destroy
    Merchant.find(params[:id]).destroy
    flash[:success] = "Merchant deleted"
    redirect_to merchants_url
	end

  def destroy_admin
    Merchant.find(params[:id]).destroy
    flash[:success] = "Merchant deleted"
    redirect_to merchants_admin_url
  end

  def current
    merchant = Merchant.find(params[:id])
    check_date = Date.today
    @current = Current.get_current_promotion(check_date,merchant)
    if @current[:promotion] != nil
        # Current promotion successfully identified
        @promotion = @current[:promotion]
        flash[:success] = @current[:message]
        render 'promotions/current'
      else
        # No current promotion found
        flash[:failure] = @current[:message]
        redirect_to merchants_url
    end    
  end

end
