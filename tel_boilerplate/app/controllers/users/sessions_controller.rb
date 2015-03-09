class Users::SessionsController < Devise::SessionsController

  respond_to :json

  before_filter :configure_permitted_parameters

  def create
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        render "users/me"
      }
    end
  end

  def destroy
    current_user.reset_authentication_token! if current_user

    respond_to do |format|
      format.html {
        super
      }
      format.json {
        head :no_content
      }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in).push()
  end

end