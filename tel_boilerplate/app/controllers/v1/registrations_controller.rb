class V1::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        build_resource(sign_up_params)

        if resource.save
          resource.update_attribute(:device_token, params[:device_token])
          sign_up(resource_name, resource)
        else
          render_object_errors(resource)
        end
      }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).concat([])
  end

end