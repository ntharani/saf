class OpussesController < ApplicationController
  before_filter :osigned_in_user,  only: [:index, :indextop, :new, :edit, :show]
  include OpussApi

  # Basic REST Actions..

  def index

    # the Opuss feed =/opusses
    # opusses
    puts "I'm in the OpussesController"
#      if osigned_in?
#      puts "Yes Signed In"
#      puts "the cookie value is #{cookies[:opuss_token]}"
      puts "I've been called for Opusses Index, I'm supplying this cookie: #{cookies[:otoken]}"
      @opusses = OpussApi.public_feed(cookies[:otoken]).parsed_response
#    else
#      puts "Not not signed in"
#      flash[:notice] = 'Please sign in'
#      render 'new'
#    end

  end

  def indextop
    @opusses = OpussApi.top_feed(cookies[:otoken]).parsed_response
  end

  def show
    # Show a particular Opuss. =/opusses/id 
    # opuss_path(opuss)
    @opuss = OpussApi.show_opuss(params[:id],cookies[:otoken])
    @showedit = cookies[:author_id]
    puts "In Opusses SHOW. Check for edit: Here is the author-id I captured during logon #{cookies[:author_id]}"
    # Use this author_id to compare to current author_id in the response object, if the two match
    # Show the "edit this Opuss" button
  end

  def new
    # Render the new Opuss form page =/opusses/new
    # opuss_new_path
  end

  def create
    # POST the Opuss
    # opusses_path
    @cresponse = OpussApi.create_opuss(params[:opuss][:opuss],params[:opuss][:title],cookies[:otoken])
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
    @response = OpussApi.show_opuss(params[:id],cookies[:otoken]).parsed_response
    unless @response["data"]["author"]["author_id"].to_s == cookies[:author_id].to_s
      redirect_to root_url, notice: "Tsk Tsk. You can't edit someone elses Opuss"
    end

  end

  def update
    # Update the Opuss Edits using a PUT to =/opusses/id
    # opuss_path(opuss)
    # Post the code here to update :)
    @uresponse = OpussApi.update_opuss(params[:id],params[:opuss][:title],params[:opuss][:opuss],cookies[:otoken])
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
    @dresponse = OpussApi.destroy_opuss(params[:id],cookies[:otoken])
    if @dresponse["error_code"].to_s !="200"
      flash.now[:error] = 'Failed. Please email support@opuss.com with the OpussID'
      render 'show'
    else
      flash[:success] = 'Done!'
      redirect_to '/opusses'
    end    
  end

  def like
    puts "In the like method, before I submit, I'm passing: #{params[:like][:like_id]} and #{cookies[:otoken]}"
    @lresponse = OpussApi.like_opuss(params[:like][:like_id],cookies[:otoken])
    puts "in the like method, this is the the response: #{@lresponse["error_code"].to_s}"
    if @lresponse["error_code"].to_s !="200"
      puts @lresponse["data"].to_s
      flash[:error] = 'Failed. Please email support@opuss.com with the OpussID'
      redirect_to '/opusses'
    else
      flash[:success] = 'Liked!'
      redirect_to '/opusses'
    end    

  end

  # Some other ones:

  #  authorfeed = get('feed/author.json', :query => {:session => '79b95801048b74977624fd143c9e9d0e', :username => 'sb2uk', :limit => 31, :output => 'json'})
  
  #  myfeed = get('feed/feed.json', :query => {:session => '79b95801048b74977624fd143c9e9d0e', :limit => 31, :output => 'json'})
  

  # Show_all: The public feed from the Opuss firehose
  # Search: Find_by (Category or Hashtag)
  # Show Categories and View Those (eg: Everything, Jokes etc.)

  private

    def osigned_in_user
      #Debug Tip: Test if signedin by raising an exception..
      #raise signed_in?.inspect
#      unless OpussApi.osigned_in?
        unless oosigned_in?
        store_location
        redirect_to new_osession_path, notice: "Please sign in first." 
      end
    end


end

