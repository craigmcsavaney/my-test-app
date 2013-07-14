class PromotionsController < ApplicationController
  load_and_authorize_resource

  def new
    @promotion = Promotion.new
  end

  def new_admin
    @promotion = Promotion.new
  end

  def create
    params[:promotion][:channel_ids] ||= []
    @promotion = Promotion.new(params[:promotion])
    if @promotion.save
	      # Handle a successful save.
	      flash[:success] = "New Promotion has been created"
	      redirect_to promotions_url
      else
        render 'new'
    end  
  end

  def create_admin
    params[:promotion][:channel_ids] ||= []
    @promotion = Promotion.new(params[:promotion])
    if @promotion.save
        # Handle a successful save.
        flash[:success] = "New Promotion has been created"
        redirect_to promotions_admin_url
      else
        render 'new_admin'
    end  
  end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def edit_admin
    @promotion = Promotion.find(params[:id])
  end

  def update
    @promotion = Promotion.find(params[:id])
    if @promotion.update_attributes(params[:promotion])
      	# Handle a successful update.
        flash[:success] = "Promotion updated"
        redirect_to promotions_url
      else
        render 'edit'
    end
  end

  def update_admin
    @promotion = Promotion.find(params[:id])
    if @promotion.update_attributes(params[:promotion])
        # Handle a successful update.
        flash[:success] = "Promotion updated"
        redirect_to promotions_admin_url
      else
        render 'edit_admin'
    end
  end

  def index
    @user = current_user
    @promotions = Promotion.where(merchant_id: @user.merchants).paginate(page: params[:page])
  end

  def index_admin
    @promotions = Promotion.paginate(page: params[:page])
  end

  def destroy
    Promotion.find(params[:id]).destroy
    flash[:success] = "Promotion deleted"
    redirect_to promotions_url
  end

  def destroy_admin
    Promotion.find(params[:id]).destroy
    flash[:success] = "Promotion deleted"
    redirect_to promotions_admin_url
  end

end
