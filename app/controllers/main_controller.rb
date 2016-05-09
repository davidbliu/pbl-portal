class MainController < ApplicationController
	skip_before_filter :is_signed_in, :only => [:cookie_hack]

  def home
  	@referrer = request.referrer# request.env["HTTP_REFERER"]
  end

  def clicks
  	render json: Click.all.map{|x| x.to_json}
  end

  def cookie_hack
  	cookies[:email] = params[:email]
  	render json: "email set to #{params[:email]}"
  end
end
