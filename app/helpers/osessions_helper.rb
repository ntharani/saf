module OsessionsHelper

  def osign_in(username, password)
   @author = OpussApi.logon(params[:osession][:username],params[:osession][:password])

    cookies.permanent[:opuss_token] = ostoken
    self.ocurrent_user = user
  end

  def signed_in?
    !ocurrent_user.nil?
  end

  def ocurrent_user=(user)
    @ocurrent_user = user
  end

  def ocurrent_user
    @ocurrent_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def ocurrent_user?(user)
    user == current_user
  end

  def osign_out
    self.ocurrent_user = nil
    cookies.delete(:opuss_token)
  end

  def ostore_location
    session[:return_to] = request.fullpath
  end

  def oredirect_back_or(default)
    redirect_to(session[:return_to] || default)
    #NB Redirect should typically be the last thing in a branch.  In rails the redirect will not execute straight away
    session.delete(:return_to)
  end

end
