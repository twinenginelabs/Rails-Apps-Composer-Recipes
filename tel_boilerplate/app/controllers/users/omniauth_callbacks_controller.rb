class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  skip_before_filter :check_registration
  
  def method_missing(provider)
    if User.omniauth_providers.index(provider)
      auth = env["omniauth.auth"]
      authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
      
      if current_user
        # If there already exists an authentication for this provider/uid, attach it to this user
        # regardless of whether it was attached to another
        if authentication
          authentication.update_attributes(:user_id => current_user.id)
        else
          current_user.authentications.(provider: auth['provider'], uid: auth['uid']).first_or_create
        end
      else
        if authentication && authentication.user
          flash[:notice] = "Signed in successfully."
          sign_in(authentication.user, :bypass => true)
        else
          user = User.new
          user.send("apply_#{auth.provider}_data", auth)
          
          if user.save
            flash[:notice] = "Account created and signed in successfully."
            sign_in(user, :bypass => true)
          else
            flash[:error] = "Error while creating a user account. Please try again."
          end
        end
      end
      
      render "devise/sessions/omniauth_complete", :layout => false
    else
      render :status => 404
    end # omniauth_providers
  end # method_missing
  
  def failure
    set_flash_message :alert, :failure, :kind => failed_strategy.name.to_s.humanize, :reason => failure_message
    render "devise/sessions/omniauth_complete", :layout => false
  end
  
end