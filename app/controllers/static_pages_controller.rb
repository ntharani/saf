class StaticPagesController < ApplicationController
  def home
  if oosigned_in?
    redirect_to opusses_path
  end
  end

  def about
  end

  def contact
  end

  def help
  end
end
