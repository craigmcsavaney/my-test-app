class GroupsController < ApplicationController
  load_and_authorize_resource
  
  # GET /groups
  def index
    @groups = Group.paginate(page: params[:page])
  end

  # GET /groups/1
  def show
    @group = Group.find(params[:id])
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  def create
    @group = Group.new(params[:group])
    if @group.save
      # Handle a successful save.
      flash[:success] = "New Group has been created"
      redirect_to groups_url
    else
      render 'new'
    end  
  end

  # PUT /groups/1
  def update
    @group = Group.find(params[:id])
    @group.updated_by = current_user
    if @group.update_attributes(params[:group])
        # Handle a successful update.
        flash[:success] = "Group updated"
        redirect_to groups_url
    else
      render 'edit'
    end
  end

  # DELETE /groups/1
  def destroy
    Group.find(params[:id]).destroy
    flash[:success] = "Group deleted"
    redirect_to groups_url
  end
end
