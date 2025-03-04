class SpatisController < ApplicationController

  def index
    @spatis = Spati.all
  end
end
