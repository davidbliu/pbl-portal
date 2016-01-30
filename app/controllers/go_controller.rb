class GoController < ApplicationController
  def redirect
    puts 'redirect controller'
    golink = GoLink.where(key: params[:key])
    if golink.length > 0
      redirect_to golink.first.url
    else
    	# do a search
      render json: 'not a valid key'
    end
  end

  def index
    me = Member.where(email:'davidbliu@gmail.com').first
  	@golinks = GoLink.order(:timestamp).last(100).select{|x| x.can_view(me)}.reverse
    @golinks = @golinks.map{|x| x.to_json}
  end

  def add
  end

  def search
    golinks = GoLink.first(10)
    render json: golinks
  end

  def insights
  end

  def update
    golink = GoLink.find(params[:id])
    if params[:title]
      golink.title = params[:title]
    end
    if params[:key]
      golink.key = params[:key]
    end
    if params[:url]
      golink.url = params[:url]
    end
    if params[:description]
      golink.description = params[:description]
    end
    golink.save!
    render json: golink.to_json

  end

end
