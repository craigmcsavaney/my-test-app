class EventsController < ApplicationController
  load_and_authorize_resource
  
  # GET /events
  def index
    @events = Event.paginate(page: params[:page])
  end

  # GET /events/1
  def show
    @event = Event.find(params[:id])
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  def create
    @event = Event.new(params[:event])
    if @event.save
      # Handle a successful save.
      flash[:success] = "New Event has been created"
      redirect_to events_url
    else
      render 'new'
    end  
  end

  # PUT /events/1
  def update
    @event = Event.find(params[:id])
    @event.updated_by = current_user
    if @event.update_attributes(params[:event])
        # Handle a successful update.
        flash[:success] = "Event updated"
        redirect_to events_url
    else
      render 'edit'
    end
  end

  # DELETE /events/1
  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "Event deleted"
    redirect_to events_url
  end
end
