class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Exception, :with => :log_error

  def log_error(exception)
    raise exception unless Rails.env.production?

    now = Time.now
    timestamp = (now.to_f*1000*1000).to_i

    SULOEXC.error '=================== UNHANDLED EXCEPTION ==================='
    SULOEXC.error "Message: #{exception.message}"

    SULOEXC.error '========================== TRACE =========================='
    exception.backtrace.each { |trace| SULOEXC.error trace }
    SULOEXC.error '=========================== $$$ ==========================='

    render json: { success: false }, status: 202
  end
end
