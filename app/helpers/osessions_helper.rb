module OsessionsHelper

  def oosign_in(ouser, type)
    puts "I'm in the OSESSIONS HELPER"
    if type.to_s == 'newlogin'
      puts "I'm of type: NEWLOGIN"
      cookies.permanent[:otoken] = ouser["data"]["session_token"]
      cookies.permanent[:username] = ouser["data"]["author"]["username"]
      cookies.permanent[:author_id] = ouser["data"]["author"]["author_id"]
      puts "If there is a access_token, this is it: #{session[:access_token]}"

      if session[:access_token]
        #redis code to make association here
        puts "A access token exists, so I'm about to set Redis data. otoken fwiw is #{cookies[:otoken]}"
        REDIS.hset('singly:opuss', cookies[:singly_id], cookies[:username])
        REDIS.hset('opuss:users', cookies[:username], cookies[:otoken] )
      end
    end

    if type.to_s == 'redisauthor'
      # cookies.permanent[:otoken] is set in the redis method.
      cookies.permanent[:username] = ouser["data"]["username"]
      cookies.permanent[:author_id] = ouser["data"]["author_id"]
    end

    puts "At the end of the OSESSIONS helper, the cookie is: #{cookies[:otoken]}"
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
    if session[:access_token]
      #delete the Redis Reference explicitly
      REDIS.hdel('singly:opuss',session[:access_token])
      cookies.delete(:singly_id)
      session.clear
    end
  end

  def sessionerr(object)
    puts "checking if the cookie or session is wierd, if so will kill it. The object error_code is: #{object["error_code"]}"
    if object["error_code"].to_s == "-500"
      self.ocurrent_user = nil
      redirect_to ssign_path
    end
  end

end


#    if request.user_agent.downcase.include?('googlebot')
#      cookies.permanent[:otoken] = OpussApi.logon('gggggg','uzuVC2Rwn8kFCktZizhT')["data"]["session_token"]
#      self.ocurrent_user = ouser
#    else
