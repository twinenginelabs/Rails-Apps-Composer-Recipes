class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :null_session, if: ->(controller) { controller.request.format == "application/json" }

  before_action :authenticate_user_from_token!
  before_action :authenticate_user!
  before_action :set_time_zone

  rescue_from(CanCan::AccessDenied) do |exception|
    if current_user
      render_error :unauthorized, "Unauthorized to perform this action."
    else
      redirect_to main_app.new_user_session_url
    end
  end

  rescue_from(ActiveRecord::RecordNotFound)  do |exception|
    render_error :bad_request, "Record was not found."
  end

  rescue_from(ActionController::ParameterMissing) do |exception|
    render_error :bad_request, "Required parameter, \"#{exception.param}\", was not sent."
  end

  rescue_from(ActionDispatch::ParamsParser::ParseError) do |exception|
    render_error :bad_request, "Invalid JSON body sent to server."
  end

  if !Rails.env.development?
    rescue_from(Exception) do |exception|
      notify_airbrake(exception)
      render_error :bad_request, exception.message
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
  
  protected

  def render_error(status, message)
    store_location

    flash[:alert] = message

    respond_to do |format|
      format.html { redirect_to main_app.root_url }
      format.json { render json: { error: message }, status: status }
    end
  end

  def render_object_errors(object)
    render json: { errors: object.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def store_location
    session[:return_to] = request.base_url + request.path
  end

  def authenticate_user_from_token!
    user_token = params[:authentication_token].presence
    user = user_token && User.find_by_authentication_token(user_token)

    if user
      sign_in user, store: false
    end
  end

  def set_time_zone
    return false unless respond_to?(:current_user) && current_user
    Time.zone = current_user.time_zone
  end
  
end