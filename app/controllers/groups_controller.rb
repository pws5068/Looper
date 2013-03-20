class GroupsController < ApplicationController

  before_filter :authenticate_user!

  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.groups

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups.to_json(:include => :users) }
    end
  end

  def shares
    group = Group.find(params[:id])
    @shares = group.shares ? group.shares : []

    respond_to do |format|
      format.json { render json: @shares }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  #def create
    #users = [ current_user ]
    #if params[:friends] # why am i passing up friends? Don't i already know who their friends are? Or are they manually selecting them?
      #users = users + User.find( params[:friends] )
    #end

    #if params[:network_friends] && current_user.fb_connected? # The whole app seems to really rely on facebook. I would remove a lot of condtional logic and just force everyone to FB connect as the app wont work at all otherwise in its present state
      #fb_users = current_user.fb_friends()

      #for friend in params[:network_friends]
        #for fb_user in fb_users
          #if fb_user['id'] == friend # huh?
            #user =  User.find_or_create_from_facebook( fb_user )
            #users << user if user
          #end
        #end
      #end
    #end

    #if users.any?
      #@group = Group.find_or_create( current_user, friends )
    #end

    #respond_to do |format| # these respond_to's are unneeded
      #if @group
        #format.json { render json: @group, status: :created, location: @group }
      #else
        #format.json { render json: false, status: :unprocessable_entity }
      #end
    #end
  #end

  def create
    if params[:network_friends] && current_user.fb_connected?
      friends = current_user.fb_friends.map do |friend|
        User.find_or_create_from_facebook( fb_user )
      end
      Group.find_or_create(current_user, friends)
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
end
