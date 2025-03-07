class StoriesController < ApplicationController
  before_action :set_story, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @stories = Story.all
  end

  def new
    @spati = Spati.find(params[:spati_id])
    @story = Story.new
  end

  def create
    @spati = Spati.find(params[:spati_id])
    @story = Story.new(story_params)
    @story.spati = @spati
    @story.user = current_user

    if @story.save
      redirect_to spati_path(@spati), notice: "You have your Story🥰"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @story = Story.find(params[:id])
    @spati = @story.spati
    # retrieve the right pet to display its info in a form
  end

  def update
    if @story.update(story_params)
      redirect_to spati_path(@spati), notice: "Your story has been updated! 🎉"
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @story.destroy
    redirect_to root_path, notice: "Your story has been deleted. 😢"
  end

  def set_story
    @story = Story.find(params[:id])
  end

  private

  def story_params
    params.require(:story).permit(:content)
  end
end
