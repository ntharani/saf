class AuthorsController < ApplicationController
  before_filter :osigned_in_user,  only: [:index, :indextop, :new, :edit, :show]
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
    @author = OpussApi.show_author(params[:id])
    puts "Received author object: #{@author}"
    puts @author
    puts "In Opusses SHOW. Check for edit: Here is the author-id I captured during logon #{cookies[:author_id]}"
    # Use this author_id to compare to current author_id in the response object, if the two match
    # Show the "edit this Opuss" button
    @showedit = cookies[:author_id]
  end

  def new
    # This form will be for a new author.
    # Sign up socially (via Singly) or Through a regular form.
  end

  def create
    # This will receive instructions from either the new #POST action or Singly.
  end


  def edit
    # This screen will render the Authors Opuss profile
  end


  def update
    # This screen will update the Authors profile.
  end

  def destroy
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

