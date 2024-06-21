class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def access_denied(exception)
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to admin_dashboard_path, alert: exception.message }
    end
  end
end
