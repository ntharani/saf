class StaticPagesController < ApplicationController
  before_filter :redis_setup

  def home
  if oosigned_in?
    redirect_to opusses_path
  end
  end

  def about
    if access_token
      @profiles = HTTParty.get(profiles_url,
        :query => {:access_token => access_token}).parsed_response
      if REDIS.hget('singly:opuss', :access_token)
        puts "Woot!, now lets check if the associated value is still valid with Opuss by doing a Opuss PING"
      else
        #puts "No associated key.  The user hasn't associated a Opuss account with their social credentials or doesn't exist.  Lets find out"
        # redirect_to sign_in page for socially triggered flow. "Hi, Looks like we haven't seen you before.."
        #flash[:notice] = "Hey there. Looks like you haven't associated an Opuss account with your social profile.  Please sign in.  You'll only have to do this once."
        #redirect_to ologin_path
      end
    end
  end

  def contact
  end

  def help
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
