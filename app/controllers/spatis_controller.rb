class SpatisController < ApplicationController

  def index
    @spatis = Spati.all
    @markers = @spatis.geocoded.map do |spati|
      {
        lat: spati.latitude,
        lng: spati.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {spati: spati})
      }
    end
  end

  def show
    @spati = Spati.find(params[:id])
    @markers = [{
      lat: @spati.latitude,
      lng: @spati.longitude
    }]
  end
end
