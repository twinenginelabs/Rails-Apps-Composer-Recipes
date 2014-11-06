class PulseController < ActionController::Base
  newrelic_ignore if respond_to?(:newrelic_ignore)

  # The pulse action. Runs <tt>select 1</tt> on the DB. If a sane result is
  # returned, 'OK' is displayed and a 200 response code is returned. If not,
  # 'ERROR' is returned along with a 500 response code.
  def pulse
    if ActiveRecord::Base.connection.execute("select 1").one?
      render :text => "<html><body>OK  #{Time.now.utc.to_s(:db)}</body></html>"
    else
      render :text => '<html><body>ERROR</body></html>', :status => :internal_server_error
    end
  end
end