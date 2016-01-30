class TestController < ApplicationController
  def test
    members = Member.all.map{|x| x.email}
    obj = {'a'=>'something',
      'emails' => members}
    render :json => obj
  end
end
