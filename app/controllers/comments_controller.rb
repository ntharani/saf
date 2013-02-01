class CommentsController < ApplicationController
  include OpussApi

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
    puts "I have been called - the create action in Comments Create"
    if params[:comment][:thecomment].to_s.blank?

      flash[:error] = "Can't be blank"
      redirect_to new_opuss_comment_path

    else

      @response = OpussApi.create_comment(params[:opuss_id],params[:comment][:thecomment],cookies[:otoken])
      puts @response["error_code"].to_s
      puts "My session ID is #{cookies[:otoken]}"
      if @response["error_code"].to_s !="200"
        flash.now[:error] = 'Failed.  Please make sure your comment has content'
      redirect_to new_opuss_comment_path
      else
        flash[:success] = 'Thanks!'
        redirect_to '/opusses'
      end

    end
  end

end
