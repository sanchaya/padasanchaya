class PadasController < ApplicationController
  before_action :set_pada, only: [:show, :edit, :update, :destroy]

  # GET /padas
  # GET /padas.json
  def index
    if params[:search] && !params[:search].blank?
      @meanings = Pada.search(params[:search])
      @similar_meanings = Pada.similar_search(params[:search]).exclude_word_ids(@meanings.pluck('id')).limit(10)

      # Search Wiktionary separately
      @wiktionary_meanings = WiktionaryEntry.search(params[:search])
      @wiktionary_similar = WiktionaryEntry.similar_search(params[:search]).where.not(id: @wiktionary_meanings.pluck(:id)).limit(10)
    else
      @random_pada = Pada.order("RAND()").first
    end
  end

  # GET /padas/1
  # GET /padas/1.json
  def show
  end

  def about
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
