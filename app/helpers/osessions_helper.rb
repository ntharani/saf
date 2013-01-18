module OsessionsHelper

  def osign_in(username, password)
    puts "In the Osessions Helper now"
    @response = OpussApi.logon(params[:osession][:username],params[:osession][:password])
    cookies.permanent[:opuss_token] = @response["data"]["session_token"]
    puts "Just assigned a cookie"
    puts "the cookie value is #{cookies[:opuss_token]}"
    #self.ocurrent_user = cookies.permanent[:opuss_token]
    return @response
  end

  def osigned_in?
    !cookies[:opuss_token].nil?
  end

  
  def osign_out
#    self.ocurrent_user = nil
    OpussApi.logoff
    flash[:notice] = 'You have been logged off'
    redirect_to root_url
    cookies.delete(:opuss_token)
    puts "I have deleted the cookie, the value is now #{cookies[:opuss_token]}"
  end

end
