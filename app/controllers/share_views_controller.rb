class ShareViewsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    respond_with ShareView.create(params[:share_view])
  end
end
