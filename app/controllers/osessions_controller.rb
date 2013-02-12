class OsessionsController < ApplicationController
before_filter :redis_setup

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
    sessionerr(@author)
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
      oosign_in(@author,'newlogin')
      flash[:success] = "Welcome to Opuss!"
      redirect_back_or root_url
  end

  def destroy
    puts "Received delete request, just in case here is the cookie #{cookies[:otoken]}"
    oosign_out
    flash[:notice] = 'See you soon!'
    redirect_to root_url
  end

  def ssign
        if access_token
      @profiles = HTTParty.get(profiles_url,
        :query => {:access_token => access_token}).parsed_response
      puts "The access token is #{access_token}"
      puts "The Singly ID is #{@profiles["id"]}"
      cookies.permanent[:singly_id]  = @profiles["id"]          
      if !REDIS.hget('singly:opuss', @profiles["id"]).blank?
        puts "Woot!, now lets check if the associated value is still valid with Opuss by trying to sign_in."
        username = REDIS.hget("singly:opuss", @profiles["id"])
        puts "The username is #{username}, the profiles id is: #{@profiles["id"]}, the cookie: #{cookies[:singly_id]}."
        rsession = REDIS.hget('opuss:users', username)
        puts "The ression value, aka the cookie is: #{rsession}"
        @author = OpussApi.show_author(username, rsession)
        #Check if I get a successful response, if so sign the user in and assign populate the cookie with the redis session token.
        if @author["error_code"].to_s == '200'
          cookies.permanent[:otoken]  = rsession
          puts "The REDIS credentials worked, proceeding to sign the user in."
          oosign_in(@author,'redisauthor')
          flash[:success] = "Welcome to Opuss!"
          redirect_back_or root_url
        else
          flash[:notice] = "Looks like your token expired. You'll need to re-associate your account"
          redirect_to ologin_path
        end
      else
        puts "We need to associate this access_token with an Opuss Profile"
        flash[:notice] = "First time to logging in? You'll need to associate your Opuss account by signing in.  You only need to do this once."
        # Be sure to add sign_out logic for access_token on sign out form.
        redirect_to ologin_path
      end
    end
  end

  private

  def access_token
    session[:access_token]
  end

  SINGLY_API_BASE = "https://api.singly.com"

  def profiles_url
    "#{SINGLY_API_BASE}/profiles"
  end

  def redis_setup
    if REDIS 
      puts "Redis is setup"
    else
      puts "Not configured"
    end
  end


end
