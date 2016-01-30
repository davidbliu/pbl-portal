module AuthHelper
  def myEmail
    cookies[:email]
  end
end
