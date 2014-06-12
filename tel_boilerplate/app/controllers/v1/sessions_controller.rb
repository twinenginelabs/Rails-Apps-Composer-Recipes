class V1::SessionsController < Devise::SessionsController

  before_filter :configure_permitted_parameters

  resource_description do
    short ""
  end

  api :POST, "/users/sign_in", "Sign in"
  param "(ProjectName) user", Hash, desc: "" do
    param :login, String, desc: "(ProjectName) Email, username, or phone number"
    param :password, String, desc: "(ProjectName) Password for login"
  end
  param "(Social) provider", String, desc: "(Social) Name of the social network being used for login (only facebook supported at the moment)"
  param "(Social) token", String, desc: "(Social) The token supplied by the social network"
  param "(Social) uid", String, desc: "(Social) The unique identifier supplied by the social network"
  param "(Social) user", Hash, desc: "(Social) A hash of all the data you want applied to the user supplied by the social network" do
    param :name, String
    param :first_name, String
    param :last_name, String
    param :location, Hash do
      param :name, String
    end
    param :gender, String
  end
  def create
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        self.resource = if (params[:provider] && params[:uid])
          User.find_or_create_relevant_user_for_provider(params[:provider], params[:uid], params[:token], params[:user], current_user)
        else
          warden.authenticate!(auth_options)
        end

        self.resource.update_attribute(:device_token, params[:device_token])

        sign_in(resource_name, resource)

        PullSocialData.perform_async(resource.id)
      }
    end
  end

  api :DELETE, "/users/sign_out", "Sign out"
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
    devise_parameter_sanitizer.for(:sign_in).concat([
      :phone_number, :facebook_token, :facebook_user
    ])
  end

end