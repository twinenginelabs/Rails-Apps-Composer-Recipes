class V1::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters, if: :devise_controller?

  resource_description do
    short ""
  end

  api :POST, "/users", "Register"
  param :user, Hash, desc: "", required: true do
    param :phone_number, String, desc: "Phone number for login", required: true
    param :password, String, desc: "Password for login", required: true
    param :password_confirmation, String, desc: "Password for login", required: true
    param :email, String, desc: "Email for user", required: false
    param :full_name, String, desc: "Full name for user", required: false
    param :gender, String, desc: "Gender for user", required: false
    param :birthday, String, desc: "Birthday for user", required: false
  end
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
    devise_parameter_sanitizer.for(:sign_up).concat([
      :phone_number, :full_name, :gender, :birthday
    ])
  end

end