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

  def self.public_feed(token)
    get('/feed/public.json', :query => {:session => token, :limit => 31})
  end

  def self.feed(token)
    get('/feed/feed.json', :query => {:session => token, :limit => 31})
  end

  def self.top_feed(token)
    get('/feed/top.json', :query => {:period => 'today', :session => token, :limit => 31})
  end

  def self.author_feed(username, token)
    get('/feed/author.json', :query => {:username => username, :session => token, :limit => 31})
  end

  def self.search(criteria, token)
    get('/feed/search.json', :query => {:criteria => criteria, :session => token, :limit => 31})
  end

  def self.show_opuss(opuss,token)
    get('/opuss/opuss.json', :query => {:session => token, :opuss_id => opuss})
  end

  def self.create_opuss(new_opuss, title, token)
    # hard code type and genre for now..
    @result = post('http://api.opuss.com/opuss/save.json', :body => {:session => token, :new_opuss => new_opuss, :type => 'Blog', :genre => 'General', :title => title }) 
    return @result
  end

  def self.update_opuss(opuss_id, title, opuss, token)
    @result = post('http://api.opuss.com/opuss/edit.json', :body => {:session => token, :opuss_id => opuss_id, :title => title, :opuss => opuss })
    return @result
  end

  def self.destroy_opuss(opuss_id, token)
    @result = post('http://api.opuss.com/opuss/delete.json', :body => {:session => token, :opuss_id => opuss_id} )
  end

  def self.like_opuss(opuss_id, token)
    @result = post('http://api.opuss.com/opuss/like.json',   :body => {:session => token, :opuss_id => opuss_id} )
  end

  def self.repost_opuss(opuss_id, token)
    @result = post('http://api.opuss.com/opuss/repost.json',   :body => {:session => token, :opuss_id => opuss_id} )
  end

####### Relevant to Osessions Controller 

  def self.osigned_in?
    puts "Am I signed in? Heres my session token: #{@session_token}"
    puts "Here is the cookie I set locally #{cookies[:opuss_token]}"
    puts "have now called the method ogetcookie"
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
      @username = @author_login["data"]["author"]["username"]
      puts "This is the session token"
      @session_token = @author_login["data"]["session_token"]
      set_token(@session_token)
      puts @session_token
    end
      return @author_login
  end

  def self.logoff(token)
    post('/session/logoff.json', :body => {:session => token })
    @session_token = nil
  end

####### Relevant to Authors Controller 

  def self.show_author(username, token)
    response = get('/author/author.json', :query => {:session => token, :username => username})
    return response
  end

  def self.author_edit(name,email,bio,token)
    @result = post('http://api.opuss.com/author/edit.json', :body => {:session => token, :name => name, :email => email, :bio => bio } )
  end


  def self.author_news(token)
    response = get('/news/news.json', :query => {:session => token})
    return response
  end

  def self.author_liked(token)
    response = get('/opuss/liked.json', :query => {:session => token})
    return response
  end

  def self.author_following(username,token)
    response = get('/author/following.json', :query => {:session => token, :username => username, :limit => 31})
  end

  def self.author_followers(username,token)
    response = get('/author/followers.json', :query => {:session => token, :username => username, :limit => 31})
  end

  def self.author_follow(username,token)
    @result = post('http://api.opuss.com/author/follow.json', :body => {:session => token, :username => username } )
  end


####### Relevant to Comments Controller 

  def self.view_comments(opuss_id,token)
    response = get('http://api.opuss.com/comment/comments.json', :query => {:session => token, :opuss_id => opuss_id, :limit => 31})
  end

  def self.create_comment(opuss_id,comment,token)
    @result = post('http://api.opuss.com/comment/save.json', :body => {:session => token, :opuss_id => opuss_id, :comment => comment } )
  end
    


  private

  def self.create_device_token
    #Eg: The identifier to the service, a random string, although tested with hard-coding "WebApp"
    @device_token = SecureRandom.urlsafe_base64
  end

  def self.set_token(token)
    #cookies.permanent.signed[:opuss_token] = @session_token
    #cookies.permanent.signed[:authorid] = @author_login["data"]["author_id"]
    #puts "In Priv method; The cookie for opuss_token is: #{cookies.permanent.signed[:opuss_token]}"
    #puts "In Priv method; The cookie for authorid is: #{cookies.permanent.signed[:opuss_token]}"
#   This method fails! (I tried setting cookies in a helper which works, but visibility is lost back here.)
#   I tried to namespace call it and that failed as well, am I missing something?
  end


end