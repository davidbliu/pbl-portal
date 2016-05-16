module AuthHelper
  def is_logged_in
    if myEmail == nil or myEmail == ''
      cookies[:auth_redirect] = request.path
      redirect_to '/auth/google_oauth2'
    end
  end
  
  def myEmail
    cookies[:email]
  end

  def current_member
  	q = Member.find_by_email(myEmail)
  end
end
