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
    @author = osign_in(params[:osession][:username],params[:osession][:password])
#    @author = OpussApi.logon(params[:osession][:username],params[:osession][:password])
    puts "Back in the Osessions controller"
    puts "Here: #{@author}"
    puts "#{@author["error_code"]} "
    puts "Did anything print or does being back mean I have no access to it?"
    if @author["error_code"].to_s !="200"
      flash.now[:error] = 'Invalid username or password'
      render 'new'
#      osign_in(@author["data"]["
    else
      flash[:success] = "Welcome to Opuss!"
      redirect_back_or '/opusses'
    end
#      puts "The session_token was nil, the user has been logged in now"
#    else
#      puts "A session exists, here's proof"
      #puts @session_token
#    end


  end

  def destroy
    osign_out
    redirect_to root_url
  end

end
