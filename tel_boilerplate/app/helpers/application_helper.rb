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

end
