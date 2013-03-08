class SharesController < ApplicationController
  
  def index
    @shares = current_user.accessible_shares.order("id desc")

    respond_to do |format|
      format.json { render json: @shares.to_json(:methods => :viewers)  }
    end
  end

  def show
    @share = Share.find(params[:id])

    respond_to do |format|
      format.json { render json: @share }
    end
  end

  def new
    @share = Share.new

    respond_to do |format|
      format.json { render json: @share }
    end
  end

  def edit
    @share = Share.find(params[:id])
  end

  def create
    @share = Share.new(params[:share])

    respond_to do |format|
      if @share.save
        format.json { render json: @share, status: :created, location: @share }
      else
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @share = Share.find(params[:id])

    respond_to do |format|
      if @share.update_attributes(params[:share])
        format.json { head :no_content }
      else
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @share = Share.find(params[:id])
    @share.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
