class MainController < ApplicationController
  def test
    @msg = 'hi my name is david'
  end

  def home
  	@referrer = request.referrer# request.env["HTTP_REFERER"]
  end
end
