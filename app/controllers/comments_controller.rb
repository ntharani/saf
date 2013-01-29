class CommentsController < ApplicationController

  def index # Show all Comments
    @comments = OpussApi.view_comments(params[:opuss_id],cookies[:otoken]).parsed_response
    if @comments["data"].to_s == "No results"
      flash[:error] = "No comments yet. Add one!"
      redirect_to new_opuss_comment_path
    end

  end

  def new 

  # I don't really need to render a new form, I can just render the form on the index page and post
  # directly to the create method
  end

  def create
  end

end
