module AuthHelper
  def myEmail
    cookies[:email]
  end

  def current_member
  	q = Member.where(email: myEmail)
  	if q.length > 0
  		return q.first
  	end
  	return nil
  end
end
