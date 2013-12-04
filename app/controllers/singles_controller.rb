class SinglesController < ApplicationController
  load_and_authorize_resource

  def create
    params[:single][:user_ids] ||= []
    params[:single][:group_ids] ||= []
		@single = Single.new(params[:single])
    if @single.save
      user=current_user
      @single.users << user
      # Handle a successful save.
      flash[:success] = "New Single has been created"
      redirect_to singles_url
    else
      render 'new'
    end  
	end

  def create_admin
    params[:single][:user_ids] ||= []
    params[:single][:group_ids] ||= []
    @single = Single.new(params[:single])
    if @single.save
      # Handle a successful save.
      flash[:success] = "New Single has been created"
      redirect_to singles_admin_url
    else
      render 'new_admin'
    end  
  end

  def new
		@single = Single.new
  end

  def new_admin
    @single = Single.new
  end

  def edit
  	@single = Single.find(params[:id])
  end

  def edit_admin
    @single = Single.find(params[:id])
  end

  def update
    params[:single][:user_ids] ||= []
    params[:single][:group_ids] ||= []
  	@single = Single.find(params[:id])
    @single.updated_by = current_user
  	if @single.update_attributes(params[:single])
    		# Handle a successful update.
      	flash[:success] = "Single updated"
    		redirect_to singles_url
  	else
			render 'edit'
		end
	end

  def update_admin
    params[:single][:user_ids] ||= []
    params[:single][:group_ids] ||= []
    @single = Single.find(params[:id])
    @single.updated_by = current_user
    if @single.update_attributes(params[:single])
        # Handle a successful update.
        flash[:success] = "Single updated"
        redirect_to singles_admin_url
    else
      render 'edit_admin'
    end
  end

  def index
    @user = current_user
  	@singles = @user.singles.order('name asc').paginate(page: params[:page])
  end

  def index_admin
    @singles = Single.order('name asc').paginate(page: params[:page])
  end

  def destroy
    Single.find(params[:id]).destroy
    flash[:success] = "Single deleted"
    redirect_to singles_url
	end

  def destroy_admin
    Single.find(params[:id]).destroy
    flash[:success] = "Single deleted"
    redirect_to singles_admin_url
  end

end
