class ApplicationController < ActionController::Base
  include ApplicationHelper
  
  before_filter :authenticate_user!
  before_filter :set_time_zone
  
  if defined?(CanCan)
    rescue_from CanCan::AccessDenied, :with => :access_denied
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
  
  def set_time_zone
    return false unless respond_to?(:current_user) && current_user
    Time.zone = current_user.time_zone
  end
  
  def store_location
    session[:return_to] = request.base_url + request.path
  end
  
  def redirect_back_or_default(default='/')
    if session[:return_to]
      redirect_to(session[:return_to])
    else
      redirect_to(default)
    end
  end
  
  protected
  
  def access_denied(exception)
    store_location
    
    flash[:alert] = current_user ? exception.message : "#{exception.message} Please login."
    
    respond_to do |format|
      format.html { redirect_to main_app.root_url }
      format.json { render json: "Access Denied" }
    end
  end
  
end