class SettingsController < ApplicationController
  load_and_authorize_resource

  def create
		@setting = Setting.new(params[:setting])
    if @setting.save
      # Handle a successful save.
      flash[:success] = "New Setting has been created"
      redirect_to settings_url
    else
      render 'new'
    end  
	end

  def new
		@setting = Setting.new
  end

  def edit
  	@setting = Setting.find(params[:id])
  end

  def update
  	@setting = Setting.find(params[:id])
    @setting.updated_by = current_user
  	if @setting.update_attributes(params[:setting])
    		# Handle a successful update.
      	flash[:success] = "Setting updated"
    		redirect_to settings_url
    else
			render 'edit'
    end
	end

  def index
  	@settings = Setting.paginate(page: params[:page])
  end

  def destroy
    Setting.find(params[:id]).destroy
    flash[:success] = "Setting deleted"
    redirect_to settings_url
	end
end