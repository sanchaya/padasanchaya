class Admin::DictionariesController < Admin::BaseController
  def index
    @dictionaries = Dictionary.order(:name)
  end

  def show
    @dictionary = Dictionary.find(params[:id])
    @entries = Pada.where(dictionary_id: params[:id]).order(:word)
    @entries = @entries.where("word LIKE ?", "%#{params[:search]}%") if params[:search].present?
    @entries = @entries.page(params[:page]).per(50) if @entries.respond_to?(:page)
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
