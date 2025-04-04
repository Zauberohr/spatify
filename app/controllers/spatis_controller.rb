class SpatisController < ApplicationController
  def index
    all_spatis = Spati.all

    if params[:all] == "true"
      @spatis = all_spatis.select(&:geocoded?)
    else
      @spatis = all_spatis.select { |s| s.open_now? && s.geocoded? }
    end

    @markers = @spatis.map do |spati|
      {
        lat: spati.latitude,
        lng: spati.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { spati: spati })
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

  def new
    @spati = Spati.new
  end

  def create
    @spati = Spati.new(spati_params)

    if params[:spati][:always_open] == "1"
      @spati.opening_time = "24/7"
    else
      opening_times = params[:opening_times].to_h.map do |day, hours|
        "#{day}: #{hours}" unless hours.blank?
      end.compact.join("; ")
      @spati.opening_time = opening_times
    end

    if @spati.save
      redirect_to @spati, notice: "Späti wurde hinzugefügt!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def spati_params
    params.require(:spati).permit(:name, :address, :always_open, photos: [])
  end
end
