class GoController < ApplicationController
  def redirect
    puts 'redirect controller'
    golink = GoLink.where(key: params[:key])
    if golink.length > 0
      redirect_to golink.first.url
    else
      render json: 'not a valid key'
    end
  end
end
