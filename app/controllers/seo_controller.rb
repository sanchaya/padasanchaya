class SeoController < ApplicationController
  skip_before_action :set_seo_defaults
  layout false

  def robots
    render plain: "User-agent: *\nAllow: /\nSitemap: https://pada.sanchaya.net/sitemap.xml\n"
  end

  def sitemap
    respond_to :xml
  end
end
