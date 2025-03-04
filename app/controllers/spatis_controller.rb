class SpatisController < ApplicationController

  def index
    @spatis = Spati.all
  end
    
  def show
    @spati = Spati.find(params[:id])
  end
end
