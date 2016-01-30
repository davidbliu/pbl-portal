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

    render json: email
    #member = nil
    #if SecondaryEmail.valid_emails.include?(email)
      #member = SecondaryEmail.email_lookup_hash[email]
    #end
    #if member != nil
      #result['member_name'] = member.name
      #cookies[:remember_token] = member.email
      #redirect_to root_path
    #else
      #@email = email
      #render no_account, layout:false
    #end
  end

  def email
    render json: myEmail
  end
end
