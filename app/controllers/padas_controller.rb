class PadasController < ApplicationController
  before_action :set_pada, only: [:show, :edit, :update, :destroy]

  # GET /padas
  # GET /padas.json
  def index
    if params[:search] && !params[:search].blank?
      @page_title = "#{params[:search]} - #{@page_title}"
      @page_description = "ಕನ್ನಡ ಪದ '#{params[:search]}' ನ ಅರ್ಥ, ವ್ಯಾಖ್ಯಾನ, ಬಳಕೆ ಮತ್ತು ಹೆಚ್ಚಿನ ಮಾಹಿತಿ. ಅನೇಕ ಕನ್ನಡ ನಿಘಂಟುಗಳಲ್ಲಿ ಹುಡುಕಿ."
      @canonical_url = root_url(search: params[:search])
      @breadcrumb_json = '{"@type":"ListItem","position":2,"name":"' + params[:search] + ' - ಹುಡುಕಾಟ ಫಲಿತಾಂಶಗಳು","item":"' + @canonical_url + '"}'
      # Step 1: Search exact word matches first
      all_meanings = Pada.search(params[:search])
      @meaning_only_results = false
      
      # Step 2: If no word matches, also search in meanings
      if all_meanings.count == 0
        all_meanings = Pada.search_by_meaning(params[:search]).limit(10)
        @meaning_only_results = true
      end
      
      # Identify special dictionary IDs (Vachana Sanchaya, Alar, etc.)
      vachana_dict = Dictionary.where('name LIKE ?', '%vachana%').first
      alar_dict = Dictionary.find_by(id: 35)
      
      special_ids = []
      special_ids << vachana_dict.id if vachana_dict
      special_ids << alar_dict.id if alar_dict
      
      if special_ids.any?
        @vachana_meanings = vachana_dict ? all_meanings.select { |m| m.dictionary_id == vachana_dict.id } : []
        @alar_meanings = alar_dict ? all_meanings.select { |m| m.dictionary_id == alar_dict.id } : []
        @meanings = all_meanings.reject { |m| special_ids.include?(m.dictionary_id) }
      else
        @meanings = all_meanings
        @vachana_meanings = []
        @alar_meanings = []
      end
      
      @similar_meanings = Pada.similar_search(params[:search]).exclude_word_ids(@meanings.pluck('id')).limit(10)
      
      # Search Wiktionary separately
      @wiktionary_meanings = WiktionaryEntry.search(params[:search])
      @wiktionary_similar = WiktionaryEntry.similar_search(params[:search]).where.not(id: @wiktionary_meanings.pluck(:id)).limit(10)
      
      # Search JanaSanchaya community dictionary
      @jana_sanchaya_meanings = JanaSanchayaEntry.search(params[:search]).ranked
      @jana_sanchaya_similar = JanaSanchayaEntry.similar_search(params[:search]).where.not(id: @jana_sanchaya_meanings.pluck(:id)).ranked.limit(5)
    else
      @random_pada = Pada.where("word NOT REGEXP '^[0-9]+$'").order("RAND()").first
    end
  end

  # GET /padas/1
  # GET /padas/1.json
  def show
  end

  def about
    @page_title = 'ನಮ್ಮ ಬಗ್ಗೆ - ಪದ ಸಂಚಯ'
    @page_description = 'ಕನ್ನಡ ನಿಘಂಟುಗಳ ಸಂಚಯ ಯೋಜನೆಯ ಬಗ್ಗೆ. ಕನ್ನಡ ಭಾಷೆ ಮತ್ತು ತಂತ್ರಜ್ಞಾನ ಕ್ಷೇತ್ರದಲ್ಲಿ ಸಂಶೋಧನೆ ಮತ್ತು ಅಭಿವೃದ್ಧಿ.'
    @breadcrumb_json = '{"@type":"ListItem","position":2,"name":"ನಮ್ಮ ಬಗ್ಗೆ","item":"https://pada.sanchaya.net/about"}'
  end

  def help
    @page_title = 'ಸಹಾಯ - ಪದ ಸಂಚಯ'
    @page_description = 'ಪದ ಸಂಚಯ ಕನ್ನಡ ನಿಘಂಟನ್ನು ಹೇಗೆ ಬಳಸುವುದು ಎಂಬುದರ ಮಾರ್ಗದರ್ಶಿ. ಪದ ಹುಡುಕಾಟ, ಸಮುದಾಯ ನಿಘಂಟು, ಮತದಾನ ಮತ್ತು ಹೆಚ್ಚಿನ ಮಾಹಿತಿ.'
    @breadcrumb_json = '{"@type":"ListItem","position":2,"name":"ಸಹಾಯ","item":"https://pada.sanchaya.net/help"}'
  end

  # GET /padas/new
  def new
    @pada = Pada.new
  end

  # GET /padas/1/edit
  def edit
  end

  # POST /padas
  # POST /padas.json
  def create
    @pada = Pada.new(pada_params)

    respond_to do |format|
      if @pada.save
        format.html { redirect_to @pada, notice: 'Pada was successfully created.' }
        format.json { render :show, status: :created, location: @pada }
      else
        format.html { render :new }
        format.json { render json: @pada.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /padas/1
  # PATCH/PUT /padas/1.json
  def update
    respond_to do |format|
      if @pada.update(pada_params)
        format.html { redirect_to @pada, notice: 'Pada was successfully updated.' }
        format.json { render :show, status: :ok, location: @pada }
      else
        format.html { render :edit }
        format.json { render json: @pada.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /padas/1
  # DELETE /padas/1.json
  def destroy
    @pada.destroy
    respond_to do |format|
      format.html { redirect_to padas_url, notice: 'Pada was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pada
      @pada = Pada.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pada_params
      params.require(:pada).permit(:word, :meaning, :pos, :language_id, :meaning_language_id, :dictionary_id)
    end
end
