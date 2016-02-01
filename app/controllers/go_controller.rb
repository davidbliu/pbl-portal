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
  	@golinks = GoLink.order(:created_at).select{|x| x.can_view(me)}.reverse.map{|x| x.to_json}
    @golinks = @golinks.paginate(:page => params[:page], :per_page => 100)
  end

  def add
    @url = params[:url]
    @key = params[:key]
  end

  def create
    if not params[:key] or not params[:url]
      render json: []
    else
      GoLink.create(
        key: params[:key], 
        url: params[:url],
        permissions: 'Anyone'
      )
      golinks = GoLink.where(key: params[:key]).to_a
      render json: golinks.map{|x| x.to_json}
    end
  end

  def lookup
    render json: GoLink.url_matches(params[:url]).map{|x| x.to_json}
  end

  def search
    golinks = GoLink.default_search(params[:q]).to_a
    render json: golinks.map{|x| x.to_json}
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

  def destroy
    GoLink.find(params[:id]).destroy
    render nothing: true, status: 200
  end

end
