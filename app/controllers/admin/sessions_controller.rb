class Admin::SessionsController < ApplicationController
  layout 'admin'

  def new
    redirect_to admin_dashboard_path if session[:admin_user_id]
  end

  def create
    admin = AdminUser.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      session[:admin_user_id] = admin.id
      redirect_to admin_dashboard_path, notice: 'ಲಾಗಿನ್ ಯಶಸ್ವಿ'
    else
      flash.now[:alert] = 'ಇಮೇಲ್ ಅಥವಾ ಪಾಸ್ವರ್ಡ್ ತಪ್ಪಾಗಿದೆ'
      render :new
    end
  end

  def destroy
    session[:admin_user_id] = nil
    redirect_to admin_login_path, notice: 'ಲಾಗೌಟ್ ಯಶಸ್ವಿ'
  end
end
