class OsessionsController < ApplicationController
include OpussApi

  def new
    # The associated form caputures the osession data: Opuss Username, Password
  end

  def create
    # On POST we take the form capture data from the #NEW action.
    # On success it gets a session token for use with other methods.
    # Signin the user, set a permanent cookie equal to the sessionID.
    # This sessionID is valid until explicitly torn down. 
    # Holy shit.. this crap makes sense.....

     puts "EXECUTE THIS CODE!!!"
     puts params.inspect
     puts "In the OSessions Controller now"
     # Check to see if the user has a cookie already.  Posting to this will automatically invalidate the last sessionID.

    #Sign in the User.
#    @author = osign_in(params[:osession][:username],params[:osession][:password])
    @author = OpussApi.logon(params[:osession][:username],params[:osession][:password])
    puts "Back in the Osessions controller"
    puts "Here: #{@author}"
    puts "#{@author["error_code"]} "
    puts "Did anything print or does being back mean I have no access to it?"
    if @author["error_code"].to_s != "200"
      flash.now[:error] = 'Invalid username or password'
      render 'new' and return
    end
      #cookies.permanent[:opuss_token] = @author["data"]["session_token"]
      #cookies.permanent[:author_id] = @author["data"]["author"]["author_id"]
      #cookies.permanent[:username] = @author["data"]["username"]
      oosign_in(@author)
      flash[:success] = "Welcome to Opuss!"
      redirect_back_or root_url
  end

  def destroy
    puts "Received delete request, just in case here is the cookie #{cookies[:otoken]}"
    oosign_out
    flash[:notice] = 'See you soon!'
    redirect_to root_url
  end

end
