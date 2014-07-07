class SharesController < ApplicationController
  load_and_authorize_resource

  def create
		@share = Share.new(params[:share])
    if @share.save
      # Handle a successful save.
      flash[:success] = "New Share has been created"
      redirect_to shares_url
    else
      render 'new'
    end  
	end

  def new
		@share = Share.new
  end

  def edit
  	@share = Share.find(params[:id])
  end

  def update
  	@share = Share.find(params[:id])
    @share.updated_by = current_user
  	if @share.update_attributes(params[:share])
    		# Handle a successful update.
      	flash[:success] = "Share updated"
    		redirect_to shares_url
    else
			render 'edit'
    end
	end

  def index
  	@shares = Share.order('id asc').paginate(page: params[:page])
  end

  def for_serve
    @shares = Share.where(serve_id: params[:serve_id]).order('id asc').paginate(page: params[:page])
    render 'index'
  end

  def destroy
    Share.find(params[:id]).destroy
    flash[:success] = "Share deleted"
    redirect_to shares_url
	end
end