class ApplicationController < ActionController::Base
  helper BootstrapFlashHelper

  # Used by devise
  def after_sign_in_path_for(user)
    dashboard_index_path
  end
end
