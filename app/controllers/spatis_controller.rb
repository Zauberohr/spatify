class SpatisController < ApplicationController
  # Nur eingeloggte Nutzer dürfen editieren & updaten
  before_action :authenticate_user!, only: [:edit, :update]

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
    elsif params[:opening_times].is_a?(ActionController::Parameters)
      opening_times = params[:opening_times].permit!.to_h.map do |day, hours|
        "#{day}: #{hours}" unless hours.blank?
      end.compact.join("; ")
      @spati.opening_time = opening_times
    else
      @spati.opening_time = ""
    end

    if @spati.save
      redirect_to @spati, notice: "Späti wurde hinzugefügt!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @spati = Spati.find(params[:id])
  end

  def update
    @spati = Spati.find(params[:id])

    if params[:spati][:always_open] == "1"
      @spati.opening_time = "24/7"
    elsif params[:opening_times].is_a?(ActionController::Parameters)
      opening_times = params[:opening_times].permit!.to_h.map do |day, hours|
        "#{day}: #{hours}" unless hours.blank?
      end.compact.join("; ")
      @spati.opening_time = opening_times
    else
      @spati.opening_time = ""
    end

    if @spati.update(spati_params)
      redirect_to @spati, notice: "Späti wurde aktualisiert!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def spati_params
    params.require(:spati).permit(:name, :address, :always_open, photos: [])
  end
end
