module OsessionsHelper

  def ggg
    return cookies[:opuss_token]
  end

  def xxosign_in(username, password)
    puts "In the Osessions Helper now"
    @response = OpussApi.logon(params[:osession][:username],params[:osession][:password])
    cookies.permanent[:opuss_token] = @response["data"]["session_token"]
    puts "Just assigned a cookie"
    puts "the cookie value is #{cookies[:opuss_token]}"
    #self.ocurrent_user = cookies.permanent[:opuss_token]
    return @response
  end

  def xxosigned_in?
    !cookies[:opuss_token].nil?
    # What happens if I push a new version of Opuss Web App? Cookie is now invalid...
    # This method needs to be more robust.  What if the cookie is incorrect?
    # Kludge: Call the author.json method (or anything with cookie session value), if the response code is anything but 200, redirect to login.
  end

  
  def xxosign_out
#    self.ocurrent_user = nil
    puts "About to delete the cookie, the value is: #{cookies[:opuss_token]}"
    OpussApi.logoff
    cookies.delete(:opuss_token)
    flash[:notice] = 'See you soon!'
    puts "I have deleted the cookie, the value is now #{cookies[:opuss_token]}"
  end

end
