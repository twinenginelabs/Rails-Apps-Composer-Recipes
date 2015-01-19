module ApplicationHelper

  # --- Engine Route Helpers

  # Regardless of current engine, search main_app for route definition first.
  # Allows us to skip the use of the "main_app." prefix when possible

  def method_missing method, *args, &block
    if main_app_url_helper?(method)
      main_app.send(method, *args)
    else
      super
    end
  end

  def respond_to?(method, include_private = false)
    main_app_url_helper?(method) || super
  end

  def main_app_url_helper?(method)
    (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
  end

  # --- Utilities

  def human_date(datetime)
    return nil unless datetime
    datetime.strftime("%a %b %e, %Y")
  end

  def human_date_time(datetime)
    return nil unless datetime
    datetime.strftime("%a %b %e, %Y @ %l:%M%p %Z")
  end

  def short_human_date(datetime)
    return nil unless datetime
    datetime.strftime("%_m/%e/%y")
  end

  def short_human_date_time(datetime)
    return nil unless datetime
    datetime.strftime("%_m/%e/%y %l:%M%p %Z")
  end

  def js_date(datetime)
    return nil unless datetime
    datetime.strftime("%Y-%m-%d")
  end

  def js_date_time(datetime)
    return nil unless datetime
    datetime.strftime("%Y-%m-%d %H:%M %p")
  end

  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
          concat content_tag(:span, 'Close', class: 'sr-only')
        end)
        concat message
      end)
    end

    nil
  end

end
