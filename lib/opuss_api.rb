require 'httparty'

module OpussApi

include HTTParty

# For the moment I'm dumping all means of access to the Opuss API here.
# Our API is relatively small
# NB: config/application.rb has autoload paths referencing the '/lib' path
# Eventually this could made into a packaged gem, but first things first :)
# NB: There is no model as everything is via a webservice API, 
# Eg: Only controllers are calling on this APIWrapper.  
# Not sure if that's a best practice or not. Suggestions welcome.
# Also trying to understand the benefit of setting the class within a module
# Also the include HTTParty is overriding ruby expected behaviour by
# extending class methods to this. Extend HTTParty doesn't seem to work

  API_KEY = 'gHy7sX007Vv'
  default_params :api_key => API_KEY
  base_uri 'http://api.opuss.com'
  format :json

  ####### Relevant to Opusses Controller 

  def self.public_feed
    get('/feed/public.json', :query => {:session => @session_token, :limit => 31})
  end

  def self.top_feed
    get('/feed/top.json', :query => {:period => 'today', :session => @session_token, :limit => 31})
  end

  def self.show_opuss(opuss)
    get('/opuss/opuss.json', :query => {:session => @session_token, :opuss_id => opuss})
  end

  def self.create_opuss
  end

  def self.update_opuss
  end

  def self.destroy_opuss
  end

  def self.osigned_in?
    puts "Am I signed in? Heres my session token: #{@session_token}"
    puts "Here is the cookie I set locally #{cookies[:opuss_token]}"
    puts "have now called the method ogetcookie"
    #new_token = OsessionsHelper.ggg
    #puts "ogetcookie returned new_token = #{new_token}"    
    return @session_token
  end

  def self.osign_out
    #cookies.delete(:opuss_token)
    puts "About to delete the cookie, the value is: #{cookies[:opuss_token]}"
    logoff
    puts "I have deleted the cookie, the value is now #{cookies[:opuss_token]}"
    @session_token = nil
    return @session_token
  end


  def self.logon(username, password)
    # if you login twice, the Api will automatically invalidate the last session_token.
    create_device_token
    @author_login = post('/session/logon.json', :body => {:username => username, :password => password, :device_token => @device_token})
    puts "The error/success code is #{@author_login["error_code"]}"
    if @author_login["error_code"].to_s !="200"
      puts "It's not sucessful!!!!"
    else
      puts "Yeah! it was successful #{@author_login["error_code"]}"
      puts @author_login["data"]["author"]["name"]
      puts "This is the session token"
      @session_token = @author_login["data"]["session_token"]
      set_token(@session_token)
      puts @session_token
    end
      return @author_login
  end

  def self.logoff
    post('/session/logoff.json', :body => {:session => cookies[:opuss_token]})
  end

  private

  def self.create_device_token
    #Eg: The identifier to the service, a random string, although tested with hard-coding "WebApp"
    @device_token = SecureRandom.urlsafe_base64
  end

  def self.set_token(token)
#    cookies.permanent.signed[:opuss_token] = token
#    This method fails! (I tried setting cookies in a helper which works, but visibility is lost back here.)
#    I tried to namespace call it and that failed as well, am I missing something?
  end


end