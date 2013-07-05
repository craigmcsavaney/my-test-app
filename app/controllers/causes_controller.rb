class CausesController < ApplicationController
  	def create
		@cause = Cause.new(params[:cause])
	    if @cause.save
	      # Handle a successful save.
	      flash[:success] = "New Cause has been created"
	      redirect_to causes_url
	    else
	      render 'new'
	    end  
	end

    def new
  		@cause = Cause.new
    end

    def edit
    	@cause = Cause.find(params[:id])
    end

    def update
    	@cause = Cause.find(params[:id])
    	if @cause.update_attributes(params[:cause])
      		# Handle a successful update.
	      	flash[:success] = "Cause updated"
      		redirect_to causes_url
		else
  			render 'edit'
  		end
	end

    def index
    	@causes = Cause.paginate(page: params[:page])
    end

    def destroy
	    Cause.find(params[:id]).destroy
	    flash[:success] = "Cause deleted"
	    redirect_to causes_url
	end
end
