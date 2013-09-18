class ServesController < ApplicationController
  load_and_authorize_resource

  def create
		@serve = Serve.new(params[:serve])
    if @serve.save
      # Handle a successful save.
      flash[:success] = "New Serve has been created"
      redirect_to serves_url
    else
      render 'new'
    end  
	end

  def new
		@serve = Serve.new
  end

  def edit
  	@serve = Serve.find(params[:id])
  end

  def show
    @serve = Serve.find(params[:id])
  end

  def update
  	@serve = Serve.find(params[:id])
    @serve.updated_by = current_user
  	if @serve.update_attributes(params[:serve])
    		# Handle a successful update.
      	flash[:success] = "Serve updated"
    		redirect_to serves_url
    else
			render 'edit'
    end
	end

  def index
  	@serves = Serve.paginate(page: params[:page])
  end

  def destroy
    Serve.find(params[:id]).destroy
    flash[:success] = "Serve deleted"
    redirect_to serves_url
	end

end