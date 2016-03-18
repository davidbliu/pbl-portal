class ApplicationController < ActionController::Base
  
  include AuthHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_filter :is_signed_in

  def unauthorized
  	render 'members/unauthorized'
  end
  
  def is_member
  	member = Member.where(email: myEmail).first
  	if not member
  		redirect_to '/unauthorized'
  	end
  end

  def is_signed_in
  	if not myEmail or myEmail == ''
  		cookies[:auth_redirect] = request.path
  		redirect_to '/auth/google_oauth2'
  	else
  		Thread.new{
            Click.create(
            	path: request.path,
            	params: request.params.to_json,
            	email: myEmail)
            ActiveRecord::Base.connection.close
         }
  	end
  end

end
