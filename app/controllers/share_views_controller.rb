class ShareViewsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    @share_view = ShareView.create(params[:share_view])
    respond_with @share_view
  end
end
