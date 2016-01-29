class TestController < ApplicationController
  def test
    obj = {'a'=>'something'}
    render :json => obj
  end
end
