class Admin::DashboardController < Admin::BaseController
  def index
    @total_community_entries = JanaSanchayaEntry.count
    @pending_entries = JanaSanchayaEntry.where(status: 'pending').count
    @approved_entries = JanaSanchayaEntry.where(status: 'approved').count
    @total_dictionaries = Dictionary.count
    @total_pada_entries = Pada.count
    @recent_entries = JanaSanchayaEntry.ranked.limit(10)
  end

  def settings
    @show_dictionary_names = Setting.get('show_dictionary_names', default: 'false')
  end

  def update_settings
    Setting.set('show_dictionary_names', params[:show_dictionary_names] == '1' ? 'true' : 'false')
    redirect_to admin_settings_path, notice: 'ಸೆಟ್ಟಿಂಗ್‌ಗಳನ್ನು ನವೀಕರಿಸಲಾಗಿದೆ'
  end

  def update_password
    admin = current_admin
    if admin.authenticate(params[:current_password])
      if params[:new_password].present? && params[:new_password].length >= 6
        if params[:new_password] == params[:confirm_password]
          admin.update(password: params[:new_password])
          redirect_to admin_settings_path, notice: 'ಪಾಸ್ವರ್ಡ್ ಬದಲಾಯಿಸಲಾಗಿದೆ'
        else
          redirect_to admin_settings_path, alert: 'ಹೊಸ ಪಾಸ್ವರ್ಡ್ ಮತ್ತು ದೃಢೀಕರಣ ಪಾಸ್ವರ್ಡ್ ಹೊಂದಿಕೆಯಾಗುತ್ತಿಲ್ಲ'
        end
      else
        redirect_to admin_settings_path, alert: 'ಹೊಸ ಪಾಸ್ವರ್ಡ್ ಕನಿಷ್ಠ 6 ಅಕ್ಷರಗಳಾಗಿರಬೇಕು'
      end
    else
      redirect_to admin_settings_path, alert: 'ಪ್ರಸ್ತುತ ಪಾಸ್ವರ್ಡ್ ತಪ್ಪಾಗಿದೆ'
    end
  end
end
