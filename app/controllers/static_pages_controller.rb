class StaticPagesController < ApplicationController
  def home
  if oosigned_in?
    redirect_to opusses_path
  end
  end

  def about
    if access_token
      @profiles = HTTParty.get(profiles_url,
        :query => {:access_token => access_token}).parsed_response
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

  
end
