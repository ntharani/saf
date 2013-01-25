class AuthorsController < ApplicationController
  before_filter :osigned_in_user,  only: [:index, :indextop, :new, :edit, :show]
  include OpussApi

  # Basic REST Actions..

  def index
    # the Authors feed =/authors
    puts "I'm in the AuthorsController"
      @authors = OpussApi.public_feed.parsed_response
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
    # Render the new Opuss form page =/opusses/new
    # opuss_new_path
  end

  def create
    # POST the Opuss
    # opusses_path
    @cresponse = OpussApi.create_opuss(params[:opuss][:opuss],params[:opuss][:title])
    if @cresponse["error_code"].to_s !="200"
      flash.now[:error] = 'Failed.  Please make sure your Opuss has content'
      render 'new'
    else
      flash[:success] = 'Thanks!'
      redirect_to '/opusses'
    end
  end


  def edit
    # Render the Edit form for a specific Opuss =/opusses/id/edit
    # opuss_path(opuss)
    # The show controller enforces whether to show the control
    # Here we need to prevent a malicious attempt to edit someone elses Opuss 
    @response = OpussApi.show_opuss(params[:id]).parsed_response
    unless @response["data"]["author"]["author_id"].to_s == cookies[:author_id].to_s
      redirect_to root_url, notice: "Tsk Tsk. You can't edit someone elses Opuss"
    end

  end

  def update
    # Update the Opuss Edits using a PUT to =/opusses/id
    # opuss_path(opuss)
    # Post the code here to update :)
    @uresponse = OpussApi.update_opuss(params[:id],params[:opuss][:title],params[:opuss][:opuss])
    if @uresponse["error_code"].to_s !="200"
      flash.now[:error] = 'Failed.  Please make sure your Opuss has content'
      render 'edit'
    else
      flash[:success] = 'Updated!'
      redirect_to '/opusses'
    end
  end

  def destroy
    # DELETE the Opuss via method: delete
    # opuss_path(opuss)
    # This one could be tricky.. might be useful to refactor the code for show/edit where
    # we verify the user committing the act is the owner of resource.. (eg: Update/Delete)
    @dresponse = OpussApi.destroy_opuss(params[:id])
    if @dresponse["error_code"].to_s !="200"
      flash.now[:error] = 'Failed. Please email support@opuss.com with the OpussID'
      render 'show'
    else
      flash[:success] = 'Done!'
      redirect_to '/opusses'
    end    
  end


  private

    def osigned_in_user
      #Debug Tip: Test if signedin by raising an exception..
      #raise signed_in?.inspect
      unless OpussApi.osigned_in?
        store_location
        redirect_to new_osession_path, notice: "Please sign in first." 
      end
    end


end

