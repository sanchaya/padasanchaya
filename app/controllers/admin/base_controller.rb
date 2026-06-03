class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :require_admin
  helper_method :current_admin

  private

  def require_admin
    unless session[:admin_user_id] && AdminUser.find_by(id: session[:admin_user_id])
      redirect_to admin_login_path, alert: 'ದಯವಿಟ್ಟು ಲಾಗಿನ್ ಮಾಡಿ'
    end
  end

  def current_admin
    @current_admin ||= AdminUser.find_by(id: session[:admin_user_id])
  end
end
