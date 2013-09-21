class ChannelsController < ApplicationController
  load_and_authorize_resource

  def create
		@channel = Channel.new(params[:channel])
    if @channel.save
      # Handle a successful save.
      flash[:success] = "New Channel has been created"
      redirect_to channels_url
    else
      render 'new'
    end  
	end

  def new
		@channel = Channel.new
  end

  def edit
  	@channel = Channel.find(params[:id])
  end

  def update
  	@channel = Channel.find(params[:id])
    @channel.updated_by = current_user
  	if @channel.update_attributes(params[:channel])
    		# Handle a successful update.
      	flash[:success] = "Channel updated"
    		redirect_to channels_url
    else
			render 'edit'
    end
	end

  def index
  	@channels = Channel.order('name asc').paginate(page: params[:page])
  end

  def destroy
    Channel.find(params[:id]).destroy
    flash[:success] = "Channel deleted"
    redirect_to channels_url
	end
end
