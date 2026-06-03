class JanaSanchayaEntriesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:vote, :remove_vote]

  def index
    @page_title = 'ಸಮುದಾಯ ನಿಘಂಟು - ಪದ ಸಂಚಯ'
    @page_description = 'ಕನ್ನಡ ಮತ್ತು ಅದರ ಉಪಭಾಷೆಗಳ ಪದಗಳ ಸಮುದಾಯ ಸಂಗ್ರಹ. ಕನ್ನಡ ಪದಗಳ ಅರ್ಥ, ಉಪಭಾಷೆ, ವ್ಯುತ್ಪತ್ತಿ ಮತ್ತು ಪರಿಸರ ಕ್ಷೇತ್ರ ಸಮೇತ.'
    @breadcrumb_json = '{"@type":"ListItem","position":2,"name":"ಸಮುದಾಯ ನಿಘಂಟು","item":"https://pada.sanchaya.net/community"}'
    @entries = JanaSanchayaEntry.ranked
    @entries = @entries.approved unless params[:show_all] == 'true'
    @entries = @entries.by_dialect(params[:dialect]) if params[:dialect].present?
    @entries = @entries.by_ecological_domain(params[:ecological_domain]) if params[:ecological_domain].present?
    @entries = @entries.by_root_language(params[:root_language]) if params[:root_language].present?
    @entries = @entries.page(params[:page]).per(20) if @entries.respond_to?(:page)
  end

  def new
    @page_title = 'ಸಮುದಾಯ ನಿಘಂಟಿಗೆ ಸೇರಿಸಿ - ಪದ ಸಂಚಯ'
    @page_description = 'ಕನ್ನಡ ಪದಗಳನ್ನು ಸಮುದಾಯ ನಿಘಂಟಿಗೆ ಸೇರಿಸಿ. ಪದ, ಅರ್ಥ, ವ್ಯಾಕರಣ, ಉಪಭಾಷೆ, ವ್ಯುತ್ಪತ್ತಿ ಮತ್ತು ಪರಿಸರ ಕ್ಷೇತ್ರ ಮಾಹಿತಿಗಳನ್ನು ನೀಡಬಹುದು.'
    @breadcrumb_json = '{"@type":"ListItem","position":2,"name":"ಸೇರಿಸಿ","item":"https://pada.sanchaya.net/contribute"}'
    @entry = JanaSanchayaEntry.new
    @entry.word = params[:word] if params[:word].present?
  end

  def create
    @entry = JanaSanchayaEntry.new(entry_params.merge(user_ip: request.remote_ip))

    if @entry.save
      redirect_to root_path(search: params[:search_word]), notice: 'ಧನ್ಯವಾದಗಳು! ನಿಮ್ಮ ಸಹಕಾರವನ್ನು ಸೇರಿಸಲಾಗಿದೆ.'
    else
      flash[:alert] = 'ದೋಷ ಸಂಭವಿಸಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.'
      if params[:search_word].present?
        redirect_to root_path(search: params[:search_word])
      else
        render :new
      end
    end
  end

  def vote
    @entry = JanaSanchayaEntry.find(params[:id])
    vote_type = params[:vote_type]

    if vote_type == 'up'
      success = @entry.upvote!(request.remote_ip)
    elsif vote_type == 'down'
      success = @entry.downvote!(request.remote_ip)
    else
      success = false
    end

    render json: {
      success: success,
      votes_up: @entry.votes_up,
      votes_down: @entry.votes_down,
      vote_score: @entry.vote_score
    }
  end

  def remove_vote
    @entry = JanaSanchayaEntry.find(params[:id])
    success = @entry.remove_vote!(request.remote_ip)

    render json: {
      success: success,
      votes_up: @entry.votes_up,
      votes_down: @entry.votes_down,
      vote_score: @entry.vote_score
    }
  end

  private

  def entry_params
    params.require(:jana_sanchaya_entry).permit(
      :word, :meaning, :pos, :language_id,
      :contributor_name, :contributor_email, :current_place,
      :dialect_place, :dialect_name, :is_dialect,
      :transliteration, :meaning_in_english,
      :synonyms, :antonyms, :usage_example, :etymology,
      :root_language, :root_word, :cognates,
      :ecological_domain, :cultural_notes
    )
  end
end
