require "httparty"

class AuthController < ApplicationController

  SINGLY_API_BASE = "https://api.singly.com"

  def callback
    auth = request.env["omniauth.auth"]
    session[:access_token] = auth.credentials.token
    redirect_to ssign_path
  end

  def logout
    session.clear
    flash[:notice] = 'See you soon!'
    redirect_to "/"
  end
end
