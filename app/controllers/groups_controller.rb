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
  def create
    users = [ current_user ]
    if params[:friends]
      users = users + User.find( params[:friends] )
    end

    if params[:network_friends] && current_user.fb_connected?
      fb_users = current_user.fb_friends()

      for friend in params[:network_friends]
        for fb_user in fb_users
          if fb_user['id'] == friend
            user =  User.find_or_create_from_facebook( fb_user )
            users << user if user
          end
        end
      end
    end

    if users.any?
      @group = Group.find_or_create( users )
    end

    respond_to do |format|
      if @group
        format.json { render json: @group, status: :created, location: @group }
      else
        format.json { render json: false, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(group_params)
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

  private
  def group_params
    params.require(:group).permit(:alias, :user)
  end
end
