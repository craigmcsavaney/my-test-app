class SalesController < ApplicationController
  load_and_authorize_resource

  def create
		@sale = Sale.new(params[:sale])
    if @sale.save
      # Handle a successful save.
      flash[:success] = "New Sale has been created"
      redirect_to sales_url
    else
      render 'new'
    end  
	end

  def new
		@sale = Sale.new
  end

  def edit
  	@sale = Sale.find(params[:id])
  end

  def update
  	@sale = Sale.find(params[:id])
    @sale.updated_by = current_user
  	if @sale.update_attributes(params[:sale])
    		# Handle a successful update.
      	flash[:success] = "Sale updated"
    		redirect_to sales_url
    else
			render 'edit'
    end
	end

  def show
    @sale = Sale.find(params[:id])
  end

  def index
  	@sales = Sale.order('id asc').paginate(page: params[:page])
  end

  def for_share
    @sales = Sale.where(share_id: params[:share_id]).order('id asc').paginate(page: params[:page])
    render 'index'
  end

  def destroy
    Sale.find(params[:id]).destroy
    flash[:success] = "Sale deleted"
    redirect_to sales_url
	end
end