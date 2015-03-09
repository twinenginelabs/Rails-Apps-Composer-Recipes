class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  respond_to :json

  # Note: Rack Middleware doesn't pick up <url>.json and so the strategy isn't
  # loaded. Use <url>?format=json instead for JSON requests.
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        respond_to do |format|
          format.html {
            if @user.persisted?
              sign_in_and_redirect @user, event: :authentication
              set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
            else
              session["devise.#{provider}_data"] = env["omniauth.auth"]
              redirect_to new_user_registration_url
            end
          }
          format.json {
            if @user.persisted?
              sign_in(:user, @user)
              render "users/me"
            else
              render_object_errors(@user)
            end
          }
        end
      end
    }
  end

  def deauthorize
    if current_user
      if @identity = current_user.identities.where(provider: params[:provider])
        @identity.destroy_all
      end
    end

    redirect_to_back_or_default
  end

  [:facebook_access_token].each do |provider|
    provides_callback_for provider
  end
  
end