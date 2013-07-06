class PromotionsController < ApplicationController
  def new
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

  def edit
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

  def index
    @promotions = Promotion.paginate(page: params[:page])
  end

  def destroy
    Promotion.find(params[:id]).destroy
    flash[:success] = "Promotion deleted"
    redirect_to promotions_url
  end
end
