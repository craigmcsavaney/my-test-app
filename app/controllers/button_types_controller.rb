class ButtonTypesController < ApplicationController
  load_and_authorize_resource

  def create
		@button_type = ButtonType.new(params[:button_type])
    if @button_type.save
      # Handle a successful save.
      flash[:success] = "New Button Type has been created"
      redirect_to button_types_url
    else
      render 'new'
    end  
	end

  def new
		@button_type = ButtonType.new
  end

  def edit
  	@button_type = ButtonType.find(params[:id])
  end

  def update
  	@button_type = ButtonType.find(params[:id])
    @button_type.updated_by = current_user
  	if @button_type.update_attributes(params[:button_type])
    		# Handle a successful update.
      	flash[:success] = "Button Type updated"
    		redirect_to button_types_url
    else
			render 'edit'
    end
	end

  def index
  	@button_types = ButtonType.order('id asc').paginate(page: params[:page])
  end

  def destroy
    ButtonType.find(params[:id]).destroy
    flash[:success] = "Button Type deleted"
    redirect_to button_types_url
	end
end