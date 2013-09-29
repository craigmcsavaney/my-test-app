class ButtonsController < ApplicationController
  load_and_authorize_resource

  def create
		@button = Button.new(params[:button])
    if @button.save
      # Handle a successful save.
      flash[:success] = "New Button has been created"
      redirect_to buttons_url
    else
      render 'new'
    end  
	end

  def new
		@button = Button.new
  end

  def edit
  	@button = Button.find(params[:id])
  end

  def update
  	@button = Button.find(params[:id])
    @button.updated_by = current_user
  	if @button.update_attributes(params[:button])
    		# Handle a successful update.
      	flash[:success] = "Button updated"
    		redirect_to buttons_url
    else
			render 'edit'
    end
	end

  def index
  	@buttons = Button.order('name asc').paginate(page: params[:page])
  end

  def destroy
    Button.find(params[:id]).destroy
    flash[:success] = "Button deleted"
    redirect_to buttons_url
	end
end
