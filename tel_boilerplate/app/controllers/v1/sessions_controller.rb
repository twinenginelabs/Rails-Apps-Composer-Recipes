class V1::SessionsController < Devise::SessionsController

  before_filter :configure_permitted_parameters

  def create
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        self.resource = if params[:auth]
          User.find_for_oauth(params[:auth], current_user)
        else
          warden.authenticate!(auth_options)
        end

        self.resource.update_attribute(:device_token, params[:device_token])

        sign_in(resource_name, resource)
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
    devise_parameter_sanitizer.for(:sign_in).concat([])
  end

end