class PromotionsController < ApplicationController
  load_and_authorize_resource :except => :serve
  
  def new
    @promotion = Promotion.new
  end

  def new_admin
    @promotion = Promotion.new
  end

  def create
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
    @promotion = Promotion.new(params[:promotion])
    if @promotion.save
        # Handle a successful save.
        flash[:success] = "New Promotion has been created"
        redirect_to promotions_admin_url
      else
        render 'new_admin'
    end  
  end

  def duplicate
    @promotion = @promotion.amoeba_dup
    if @promotion.save
        # Handle a successful save.
        flash[:success] = "Promotion has been duplicated"
        redirect_to promotions_url
      else
        flash[:failure] = "Duplication failed"
        redirect_to promotions_url
    end  
  end

  def duplicate_admin
    @promotion = @promotion.amoeba_dup
    if @promotion.save
        # Handle a successful save.
        flash[:success] = "Promotion has been duplicated"
        redirect_to promotions_admin_url
      else
        flash[:failure] = "Duplication failed"
        redirect_to promotions_admin_url
    end  
  end


  def edit
    @promotion = Promotion.find(params[:id])
  end

  def edit_admin
    @promotion = Promotion.find(params[:id])
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

  def show_admin
    @promotion = Promotion.find(params[:id])
  end

  def update
    params[:promotion][:channel_ids] ||= []
    @promotion = Promotion.find(params[:id])
    @promotion.updated_by = current_user
    if @promotion.update_attributes(params[:promotion])
        # Handle a successful update.
        flash[:success] = "Promotion updated"
        redirect_to promotions_url
      else
        render 'edit'
    end
  end

  def update_admin
    params[:promotion][:channel_ids] ||= []
    @promotion = Promotion.find(params[:id])
    @promotion.updated_by = current_user
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
    @promotion = Promotion.find(params[:id])
    if @promotion.destroy
        flash[:success] = "Promotion deleted"
        redirect_to promotions_url
      else
        flash[:failure] = "The promotion was not deleted"
        redirect_to promotions_url
    end
  end

  def destroy_admin
    @promotion = Promotion.find(params[:id])
    if @promotion.destroy
        flash[:success] = "Promotion deleted"
        redirect_to promotions_admin_url
      else
        flash[:failure] = "The promotion was not deleted"
        redirect_to promotions_admin_url
    end
  end

  def serve
    # accepts Merchant id as input
    # Get merchant's current promotion
    merchant = Merchant.find(params[:merchant_id])
    check_date = Date.today
    @current = Current.get_current_promotion(check_date,merchant)
    if @current[:promotion] != nil
        # Current promotion successfully identified
        @promotion = @current[:promotion]
        flash[:success] = @current[:message]
        respond_to do |format|
          format.html { render 'current' }
          format.json { render json: @promotion }
        end
    # record serve event in Serve
    Serve.create(promotion_id: @promotion.id)
      else
        # No current promotion found
        flash[:failure] = @current[:message]
        redirect_to merchants_url
    end    
  end

  def current
    merchant = Merchant.find(params[:merchant_id])
    check_date = Date.today
    @current = Current.get_current_promotion(check_date,merchant)
    if @current[:promotion] != nil
        # Current promotion successfully identified
        @promotion = @current[:promotion]
        flash[:success] = @current[:message]
        respond_to do |format|
          format.html { render 'current' }
          format.json { render json: @promotion }
        end
      else
        # No current promotion found
        flash[:failure] = @current[:message]
        redirect_to merchants_url
    end    
  end
end
