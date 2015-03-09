class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :null_session, if: ->(controller) { controller.request.format == "application/json" }

  before_action :authenticate_user_from_token
  before_action :authenticate_user!, except: :routing_error
  before_action :redirect_admin
  around_action :set_time_zone

  rescue_from(Exception) do |exception|
    notify_airbrake(exception)
    render_error :internal_server_error, Rails.env.production? ? I18n.t("errors.server_error") : exception.message
  end unless Rails.env.development?

  rescue_from(ActionDispatch::ParamsParser::ParseError) do |exception|
    render_error :bad_request, I18n.t("errors.parse_error")
  end

  rescue_from(ActionController::ParameterMissing) do |exception|
    render_error :bad_request, I18n.t("errors.parameter_missing", parameter: exception.param)
  end

  rescue_from(ActiveRecord::RecordNotFound)  do |exception|
    render_error :not_found, I18n.t("errors.record_not_found")
  end

  rescue_from(ActionController::RoutingError) do |exception|
    render_error :not_found, I18n.t("errors.routing_error")
  end

  rescue_from(ActiveRecord::RecordInvalid) do |exception|
    render_error :unprocessable_entity, exception.message
  end

  rescue_from(CanCan::AccessDenied) do |exception|
    if current_user
      render_error :unauthorized, I18n.t("errors.not_authorized")
    else
      redirect_to main_app.new_user_session_url
    end
  end

  def routing_error
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
  
  protected

  def redirect_to_back_or_default(default = root_url)
    if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to default
    end
  end

  def render_error(status, message)
    store_location

    respond_to do |format|
      format.html { render "errors/status", locals: { error: message }, status: status, layout: "application" }
      format.json { render json: { error: message }, status: status }
    end
  rescue ActionController::UnknownFormat
    render status: status, text: message
  end

  def render_object_errors(object)
    render json: { error: object.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def authenticate_user_from_token
    user_token = params[:authentication_token].presence
    user = user_token && User.find_by_authentication_token(user_token)

    if user
      sign_in user, store: false
    end
  end

  def store_location
    session[:return_to] = request.base_url + request.path
  end

  def redirect_admin
    if current_user && current_user.admin? && !rails_admin_controller? && !devise_controller?
      redirect_to rails_admin.dashboard_path
    end
  end

  def set_time_zone(&block)
    time_zone = if request.cookies["time_zone"]
      ActiveSupport::TimeZone[-request.cookies["time_zone"].to_i.minutes]
    else
      current_user.try(:time_zone) || "UTC"
    end

    Time.use_zone(time_zone, &block)
  end

  def rails_admin_controller?
    is_a?(RailsAdmin::MainController)
  end
  
end