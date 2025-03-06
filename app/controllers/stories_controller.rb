class StoriesController < ApplicationController
  before_action :set_story, only: [:edit, :update, :destroy]

  def index
    @stories = Story.all
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(story_params)
    if @story.save
      redirect_to root_path, notice: "You have your Story🥰"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @story.update(story_params)
      redirect_to root_path, notice: "Your story has been updated! 🎉"
    else
      render :edit, status: :unprocessable_entity
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
    params.require(:story).permit(:title, :content)
  end
end
