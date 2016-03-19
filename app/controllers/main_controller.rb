class MainController < ApplicationController
	skip_before_filter :is_signed_in, :only => [:cookie_hack]
  def test
    @msg = 'hi my name is david'
  end

  def home
  	@referrer = request.referrer# request.env["HTTP_REFERER"]
  end

  def clicks
  	render json: Click.all.map{|x| x.to_json}
  end

  def cookie_hack
  	cookies[:email] = 'e1@g'
  	render json: 'hacked da cookie'
  end
end
