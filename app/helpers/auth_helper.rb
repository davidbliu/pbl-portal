module AuthHelper
  def myEmail
    cookies[:email]
  end

  def current_member
    # return Member.where(email:'claire.c@berkeley.edu').first
  	q = Member.where(email: myEmail)
  	if q.length > 0
  		return q.first
  	end
  	return nil
  end
end
