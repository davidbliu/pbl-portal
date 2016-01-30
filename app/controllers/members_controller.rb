class MembersController < ApplicationController
  def me
    w = Member.where(email:myEmail)
    if w.length > 0
      me = w.first
      render json: me.to_json
    else
      render json: nil
    end
  end

  def update
    render json: params
  end
end
