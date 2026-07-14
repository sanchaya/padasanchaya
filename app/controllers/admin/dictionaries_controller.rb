class Admin::DictionariesController < Admin::BaseController
  def index
    @dictionaries = Dictionary.left_joins(:padas)
                              .select('dictionaries.*, COUNT(padas.id) as pada_count')
                              .group('dictionaries.id')
                              .order(:name)
    @total_entries = Pada.count
    @total_dictionaries = Dictionary.count
    @total_pos_tags = Pada.where.not(pos: nil).count
    @total_root_languages = Pada.where.not(root_language: nil).count
  end

  def show
    @dictionary = Dictionary.find(params[:id])
    @entries = Pada.where(dictionary_id: params[:id]).order(:word)
    @entries = @entries.where("word LIKE ?", "%#{params[:search].unicode_normalize(:nfkc)}%") if params[:search].present?
    @entries = @entries.page(params[:page]).per(50) if @entries.respond_to?(:page)

    @total_padas = Pada.where(dictionary_id: @dictionary.id).count
    @pos_distribution = Pada.where(dictionary_id: @dictionary.id).where.not(pos: nil).group(:pos).order('count_id DESC').limit(10).count
    @root_language_distribution = Pada.where(dictionary_id: @dictionary.id).where.not(root_language: nil).group(:root_language).order('count_id DESC').limit(10).count
    @entries_with_pos = Pada.where(dictionary_id: @dictionary.id).where.not(pos: nil).count
    @entries_with_root_lang = Pada.where(dictionary_id: @dictionary.id).where.not(root_language: nil).count
    @entries_with_synonyms = Pada.where(dictionary_id: @dictionary.id).where.not(synonyms: nil).count
  end

  def edit
    @dictionary = Dictionary.find(params[:id])
  end

  def update
    @dictionary = Dictionary.find(params[:id])
    if @dictionary.update(dictionary_params)
      redirect_to admin_dictionaries_path, notice: 'ನಿಘಂಟನ್ನು ನವೀಕರಿಸಲಾಗಿದೆ'
    else
      render :edit
    end
  end

  def edit_entry
    @pada = Pada.find(params[:id])
  end

  def update_entry
    @pada = Pada.find(params[:id])
    if @pada.update(pada_params)
      redirect_to admin_dictionary_path(@pada.dictionary_id), notice: 'ನಮೂದನ್ನು ನವೀಕರಿಸಲಾಗಿದೆ'
    else
      render :edit_entry
    end
  end

  private

  def dictionary_params
    params.require(:dictionary).permit(
      :name, :core_name, :dictionary_type, :multilingual, :category,
      :description, :publisher, :published_year, :total_entries,
      :show_name_in_search
    )
  end

  def pada_params
    params.require(:pada).permit(
      :word, :meaning, :pos,
      :synonyms, :root_language, :root_word, :cognates,
      :etymology, :short_description, :long_description,
      :kannada_pronunciation, :administrative_word, :department
    )
  end
end
