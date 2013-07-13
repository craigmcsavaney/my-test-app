class TestusersController < ApplicationController
  # GET /testusers
  # GET /testusers.json
  def index
    @testusers = Testuser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @testusers }
    end
  end

  # GET /testusers/1
  # GET /testusers/1.json
  def show
    @testuser = Testuser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @testuser }
    end
  end

  # GET /testusers/new
  # GET /testusers/new.json
  def new
    @testuser = Testuser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @testuser }
    end
  end

  # GET /testusers/1/edit
  def edit
    @testuser = Testuser.find(params[:id])
  end

  # POST /testusers
  # POST /testusers.json
  def create
    @testuser = Testuser.new(params[:testuser])

    respond_to do |format|
      if @testuser.save

        # Tell the UserMailer to send a welcome Email after save
        TestMailer.welcome_email(@testuser).deliver

        format.html { redirect_to @testuser, notice: 'Testuser was successfully created.' }
        format.json { render json: @testuser, status: :created, location: @testuser }
      else
        format.html { render action: "new" }
        format.json { render json: @testuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /testusers/1
  # PUT /testusers/1.json
  def update
    @testuser = Testuser.find(params[:id])

    respond_to do |format|
      if @testuser.update_attributes(params[:testuser])
        format.html { redirect_to @testuser, notice: 'Testuser was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @testuser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /testusers/1
  # DELETE /testusers/1.json
  def destroy
    @testuser = Testuser.find(params[:id])
    @testuser.destroy

    respond_to do |format|
      format.html { redirect_to testusers_url }
      format.json { head :no_content }
    end
  end
end
