class ShareViewsController < ApplicationController

  respond_to :json

  def create
    @share_view = ShareView.create(params[:share_view])
    respond_with @share_view
  end
end
