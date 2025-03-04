class SpatiesController < ApplicationController

  def show
    @spati = Spati.find(params[:id])
  end
end
