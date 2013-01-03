require "rubygems"
require "httparty"

class Opuss
  include HTTParty
  base_uri "api.opuss.com"

  def self.authorinfo
    get("/author/author.json?api_key=gHy7sX007Vv&username=sb2uk&session=79b95801048b74977624fd143c9e9d0e")
  end

end
