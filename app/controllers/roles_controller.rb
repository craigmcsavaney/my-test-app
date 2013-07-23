class RolesController < ApplicationController
  load_and_authorize_resource
  
  # GET /roles
  def index
    @roles = Role.paginate(page: params[:page])
  end

  # GET /roles/1
  def show
    @role = Role.find(params[:id])
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
  end

  # POST /roles
  def create
    @role = Role.new(params[:role])
    if @role.save
      # Handle a successful save.
      flash[:success] = "New Role has been created"
      redirect_to roles_url
    else
      render 'new'
    end  
  end

  # PUT /roles/1
  def update
    @role = Role.find(params[:id])
    @role.updated_by = current_user
    if @role.update_attributes(params[:role])
        # Handle a successful update.
        flash[:success] = "Role updated"
        redirect_to roles_url
    else
      render 'edit'
    end
  end

  # DELETE /roles/1
  def destroy
    Role.find(params[:id]).destroy
    flash[:success] = "Role deleted"
    redirect_to roles_url
  end
end
