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
end
