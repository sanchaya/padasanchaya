class ApplicationController < ActionController::Base

  before_action :set_local_language
  before_action :set_seo_defaults

  def set_local_language
    I18n.locale = 'kn'
  end

  def set_seo_defaults
    @page_title = 'ಪದ ಸಂಚಯ - ಕನ್ನಡ ನಿಘಂಟುಗಳ ಸಂಚಯ'
    @page_description = 'ಕನ್ನಡ ಪದಗಳ ಅರ್ಥ, ಬಳಕೆ, ವ್ಯುತ್ಪತ್ತಿ, ಉಪಭಾಷೆ ಮತ್ತು ಪರಿಸರ ಕ್ಷೇತ್ರ ಸಮೇತ ಹುಡುಕಿ. ಅನೇಕ ಕನ್ನಡ ನಿಘಂಟುಗಳ ಒಂದು ಸಂಗ್ರಹ.'
    @page_keywords = 'ಕನ್ನಡ ನಿಘಂಟು, kannada dictionary, ಕನ್ನಡ ಪದಕೋಶ, ಪದದ ಅರ್ಥ, kannada word meaning, ಕನ್ನಡ ಶಬ್ದಕೋಶ, ನಿಘಂಟು, pada sanchaya, vachana sanchaya'
    @page_image = 'https://vachana.sanchaya.net/app-icon-light.png'
    @canonical_url = request.original_url.split('?').first
  end
end
