class Admin::CommunityEntriesController < Admin::BaseController
  before_action :set_entry, only: [:show, :edit, :update, :destroy]

  def index
    @entries = JanaSanchayaEntry.ranked
    @entries = @entries.by_dialect(params[:dialect]) if params[:dialect].present?
    @entries = @entries.by_ecological_domain(params[:ecological_domain]) if params[:ecological_domain].present?
    @entries = @entries.by_root_language(params[:root_language]) if params[:root_language].present?
    @entries = @entries.where(status: params[:status]) if params[:status].present?
    @entries = @entries.page(params[:page]).per(30) if @entries.respond_to?(:page)
  end

  def show
  end

  def edit
  end

  def update
    if @entry.update(entry_params)
      redirect_to admin_community_entries_path, notice: 'ನಮೂದನ್ನು ನವೀಕರಿಸಲಾಗಿದೆ'
    else
      render :edit
    end
  end

  def destroy
    @entry.destroy
    redirect_to admin_community_entries_path, notice: 'ನಮೂದನ್ನು ಅಳಿಸಲಾಗಿದೆ'
  end

  private

  def set_entry
    @entry = JanaSanchayaEntry.find(params[:id])
  end

  def entry_params
    params.require(:jana_sanchaya_entry).permit(
      :word, :meaning, :pos, :language_id, :status,
      :contributor_name, :contributor_email, :current_place,
      :dialect_place, :dialect_name, :is_dialect,
      :transliteration, :meaning_in_english,
      :synonyms, :antonyms, :usage_example, :etymology,
      :root_language, :root_word, :cognates,
      :ecological_domain, :cultural_notes
    )
  end
end
