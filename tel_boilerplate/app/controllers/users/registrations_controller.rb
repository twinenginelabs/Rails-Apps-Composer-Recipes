class Users::RegistrationsController < Devise::RegistrationsController

  respond_to :json

  before_action :configure_permitted_parameters

  def create
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        build_resource(sign_up_params)

        if resource.save
          sign_up(resource_name, resource)
          render "users/me"
        else
          render_object_errors(resource)
        end
      }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name, :username)
  end

end