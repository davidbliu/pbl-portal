class AuthController < ApplicationController
  def google_callback
    result = Hash.new
    authentication_info = request.env["omniauth.auth"]
    
    cookies[:access_token] = authentication_info["credentials"]["token"]
    cookies[:refresh_token] = authentication_info["credentials"]["refresh_token"]
    
    provider = authentication_info['provider']
    uid = authentication_info['uid']
    email = authentication_info['info']['email']

    cookies[:uid] = uid
    cookies[:provider] = provider
    cookies[:email] = email

    # render json: 'logged in as ' + email
    redirect_to '/me'
  end

  def email
    render json: myEmail
  end
end
