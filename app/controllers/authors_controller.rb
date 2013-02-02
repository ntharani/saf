class AuthorsController < ApplicationController
  before_filter :osigned_in_user,  except: [:new, :create]
  include OpussApi

  # Basic REST Actions..

  def index
    # the Authors feed =/authors
    puts "I'm in the AuthorsController"
      @authors = OpussApi.public_feed(cookies[:otoken]).parsed_response
  end

  def show
    # Show a particular Author. =/authors/id 
    # author_path(author)
    @author = OpussApi.show_author(params[:id],cookies[:otoken])
    puts "Received author object: #{@author}"
    puts @author
    puts "In Opusses SHOW. Check for edit: Here is the author-id I captured during logon #{cookies[:author_id]}"
    # Use this author_id to compare to current author_id in the response object, if the two match
    # Show the "edit this Opuss" button
    @showedit = cookies[:author_id]
    if @showedit.to_s == @author["data"]["author_id"].to_s
      @news = OpussApi.author_news(cookies[:otoken])
      @liked = OpussApi.author_liked(cookies[:otoken])
    else
      @liked = OpussApi.author_liked(cookies[:otoken])

      @vnews = OpussApi.vauthor_news(@author["data"]["username"],cookies[:otoken])
    end
  end

  def new
      if oosigned_in?
        flash[:error] = 'Please explicitly sign out first'
        redirect_to opusses_path
      end
    # This form will be for a new author.
    # Sign up socially (via Singly) or Through a regular form.
  end

  def create
    # This will receive instructions from either the new #POST action or Singly.
    if params[:author][:password] == params[:author][:password_verify] && !params[:author][:password].blank?
      puts "Passwords are not blank and match"
    else
      flash.now[:error] = 'Password does not match and must not be blank'
      render 'new' and return
    end
      
    @bresponse = OpussApi.username(params[:author][:username]).parsed_response
    puts @bresponse
    if @bresponse["error_code"].to_s == "200"
      puts "It's available"
    else
      flash.now[:error] = 'Username not available'
      render 'new' and return
    end

    @cresponse = OpussApi.author_register(params[:author][:username],params[:author][:email].downcase,params[:author][:password])
    if @cresponse["error_code"].to_s == "200"
      puts "Wahey! you're in!"
      flash[:sucess] = "Signup successful, please login with your new details"
      redirect_to ologin_path
    else
      flash.now[:error] = 'Something went wrong, please email support@opuss.com. Thanks.'
      render 'new' and return
    end
  end


  def edit
    @response = OpussApi.show_author(params[:id],cookies[:otoken])
    unless @response["data"]["author_id"].to_s == cookies[:author_id].to_s
      redirect_to root_url, notice: "Tsk Tsk. You can't edit someone elses profile"
    end
  end


  def update
    # This screen will update the Authors profile.
    @uresponse = OpussApi.author_edit(params[:author][:name],params[:author][:email],params[:author][:bio],cookies[:otoken])
    if @uresponse["error_code"].to_s !="200"
      flash.now[:error] = 'Failed.  Please make sure your profile has content'
      render 'edit'
    else
      flash[:success] = 'Updated!'
      redirect_to author_path(params[:id])
    end
  end

  def destroy
  end

  def following
    @author = OpussApi.author_following(params[:id],cookies[:otoken]).parsed_response
  end

  def followed
    @author = OpussApi.author_followers(params[:id],cookies[:otoken]).parsed_response
  end

  def follow
    @fresponse = OpussApi.author_follow(params[:follow][:follow_id],cookies[:otoken])
    if @fresponse["error_code"].to_s !="200"
      puts @lresponse["data"].to_s
      flash[:error] = 'Failed. Please email support@opuss.com with the OpussID'
      redirect_to author_path(params[:follow][:follow_id])
    else
      flash[:success] = 'Done!'
      redirect_to author_path(params[:follow][:follow_id])
    end    

  end


  private

    def osigned_in_user

#   This method is exactly identical to one in opussescontroller - but when invoked here
#   it causes the user to continuously login.  What am I missing?

#     unless OpussApi.osigned_in?
      unless oosigned_in?
        store_location
        redirect_to new_osession_path, notice: "Please sign in first." 
      end
    end


end

