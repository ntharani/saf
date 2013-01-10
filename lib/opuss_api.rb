require 'httparty'

class OpussApi

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
    get('/feed/public.json', :query => {:session => '79b95801048b74977624fd143c9e9d0e', :limit => 31})
  end

  def self.show_opuss(opuss)
    get('/opuss/opuss.json', :query => {:session => '79b95801048b74977624fd143c9e9d0e', :opuss_id => opuss})
  end

  def self.create_opuss
  end

  def self.update_opuss
  end

  def self.destroy_opuss
  end

end