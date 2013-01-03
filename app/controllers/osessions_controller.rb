require 'rubygems'
require 'httparty'
require 'json'


class OsessionsController < ApplicationController

  include HTTParty
  default_params :api_key => 'gHy7sX007Vv'
  API_KEY = 'gHy7sX007Vv'
  base_uri 'http://api.opuss.com'
  format :json

  def new
    # The associated form caputures the osession data: Opuss Username, Password
  end

  def create


    # On POST success it gets a session token for use with other methods.
    # Signin the user, set a permanent cookie equal to the sessionID.
    # This sessionID is valid until explicitly torn down. 
    # Holy shit.. this crap makes sense..... mostly

    # Can't refactor base_uri out, it's a method, but doesn't work on a create action?
    # Same with the default_params :api_key, nada - has to be explictly stated, but only here.
    # works in self.author_info.. 

    @ouser = HTTParty.get('http://api.opuss.com/author/author.json', :query => {:api_key => API_KEY, :username => 'sb2uk', :session => '79b95801048b74977624fd143c9e9d0e'})
    render 'index'
  end

  def self.author_info
    @ouser = get('/author/author.json', :query => {:username => 'sb2uk', :session => '79b95801048b74977624fd143c9e9d0e', :output => 'json'})
  end

  def self.feed_public
    feedpublic = get('/feed/public.json', :query => {:session => '79b95801048b74977624fd143c9e9d0e', :limit => 31, :output => 'json'})
  end


  def self.diditset
    puts @ouser
  end


  def destroy
  end

end

# /author/author.json?api_key=gHy7sX007Vv&username=sb2uk&session=79b95801048b74977624fd143c9e9d0e

