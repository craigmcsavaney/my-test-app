class DonationsController < ApplicationController
  load_and_authorize_resource

  def create
		@donation = Donation.new(params[:donation])
    if @donation.save
      # Handle a successful save.
      flash[:success] = "New Donation has been created"
      redirect_to donations_url
    else
      render 'new'
    end  
	end

  def new
		@donation = Donation.new
  end

  def edit
  	@donation = Donation.find(params[:id])
  end

  def update
  	@donation = Donation.find(params[:id])
    @donation.updated_by = current_user
  	if @donation.update_attributes(params[:donation])
    		# Handle a successful update.
      	flash[:success] = "Donation updated"
    		redirect_to donations_url
    else
			render 'edit'
    end
	end

  def show
    @donation = Donation.find(params[:id])
  end

  def show_admin
    @donation = Donation.find(params[:id])
  end

  def index
    @user = current_user
  	#@donations = Donation.where("choosers_email = ?",@user.email).order('created_at desc').paginate(page: params[:page])
    @donations = Donation.where("chooser_id = ? or buyer_id = ? or supporter_id = ?",@user.id,@user.id,@user.id).order('created_at desc').paginate(page: params[:page])
  end

  def index_admin
    @donations = Donation.order('created_at desc').paginate(page: params[:page])
  end

  def destroy
    Donation.find(params[:id]).destroy
    flash[:success] = "Donation deleted"
    redirect_to donations_url
	end
end