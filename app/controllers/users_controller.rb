class UsersController < ApplicationController
#	before_filter :authenticate_user!
	load_and_authorize_resource

	def show
	  @user = User.find(params[:id])
	end

	def index
    	@users = User.paginate(page: params[:page])
    end

    def edit
    	@user = User.find(params[:id])
  	end

  	def update
  		params[:user][:role_ids] ||= []
  		@user = User.find(params[:id])
  		if @user.update_attributes(params[:user])
	      	# Handle a successful update.
	      	flash[:success] = "User updated"
	      	redirect_to users_url
	      else
	      	render 'edit'
	      end
	end
end
