module OsessionsHelper

  def oosign_in(ouser)
    puts "I'm in the OSESSIONS HELPER"
    cookies.permanent[:otoken] = ouser["data"]["session_token"]
    cookies.permanent[:username] = ouser["data"]["author"]["username"]
    puts "In the OSESSIONS helper, the cookie is: #{cookies[:otoken]}"
    self.ocurrent_user = ouser
  end

  def oosigned_in?
    puts "In the oosigned_in? method"
    !ocurrent_user.nil?
  end

  def ocurrent_user=(ouser)
    @ocurrent_user = ouser
  end

  def ocurrent_user
    @ocurrent_user ||= cookies[:otoken]
  end

  def ocurrent_user?(ouser)
    ouser == ocurrent_user
  end

  def oosign_out
    puts "oSessions Helper: Received delete request, just in case here is the cookie #{cookies[:otoken]}"
    self.ocurrent_user = nil
    OpussApi.logoff(cookies[:otoken])
    cookies.delete(:otoken)
    cookies.delete(:username)
  end

end
