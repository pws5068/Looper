class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # this looks great but I meta programmed mine a little bit to make it easier for more methods
  # https://github.com/MikeSilvis/shindig/blob/master/app/controllers/users/omniauth_callbacks_controller.rb
  def all
    user = User.from_omniauth( request.env['omniauth.auth'] )
    if user.persisted?
      sign_in_and_redirect user
    else
      session['devise.user_attributes'] = user.attributes
      redirect_to new_user_registration_path
    end
  end
  alias_method :facebook, :all
end
