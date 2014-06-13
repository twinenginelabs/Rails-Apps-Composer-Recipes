class ExceptionsController < ApplicationController

  def render_status
    @exception = env["action_dispatch.exception"]
    @status_code = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code
    render @status_code.to_s, status: @status_code, layout: true
  end

end