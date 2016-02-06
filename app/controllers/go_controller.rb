class GoController < ApplicationController
  def redirect
    if params[:key].include?('wiki:')
      term = params[:key].split(':')[1]
      redirect_to 'http://wd.berkeley-pbl.com/wiki/index.php/Special:Search/'+term
    elsif params[:key].include?('drive:')
      term = params[:key].split(':')[1]
      render json: 'should search the drive for ' + term  
    else
      viewable = GoLink.can_view(current_member)
      golink = GoLink.where(key: params[:key])
        .where('id in (?)', viewable)
      if golink.length > 1
        # redirect_to golink.first.url
        @golinks = golink
        @permissions_list = GoLink.permissions_list
        render :template => "go/add"
      elsif golink.length == 1
        redirect_to golink.first.url
      else
      	# do a search
        redirect_to '/go?q='+params[:key]
      end
    end
  end

  def index
    me = current_member

    viewable = GoLink.can_view(me)
    if params[:q]
      @golinks = GoLink.member_search(params[:q], current_member)
    else
    	@golinks = GoLink.order(:created_at)
        .where('id in (?)',viewable)
        .where.not(key: 'change-this-key')
        .reverse.map{|x| x.to_json}
    end
    @golinks = @golinks.paginate(:page => params[:page], :per_page => 100)
    @permissions_list = GoLink.permissions_list
  end

  def add3
    @url = params[:url]
    @key = params[:key]
  end

  def add


    if params[:key]
      @golink = GoLink.create(
        key: params[:key],
        description: params[:desc],
        url: params[:url],
        member_email: current_member.email,
        permissions: 'Anyone',
        semester: Semester.current_semester
      )
      @golinks = GoLink.where(key: @golink.key).map{|x| x.to_json}

    else
      @golink = GoLink.create(
        member_email: current_member.email,
        key: 'change-this-key',
        url: 'http://change_this_url.com',
        permissions: 'Anyone',
        semester: Semester.current_semester
      )
      @golinks = [@golink]
    end
    @permissions_list = GoLink.permissions_list
  end

  def create
    if not params[:key] or not params[:url] or params[:key] = '' or params[:url] = ''
      render json: []
    else
      GoLink.create(
        key: params[:key], 
        url: params[:url],
        permissions: 'Anyone',
        member_email: current_member.email
      )
      golinks = GoLink.where(key: params[:key]).to_a
      render json: golinks.map{|x| x.to_json}
    end
  end

  def lookup
    render json: GoLink.url_matches(params[:url]).map{|x| x.to_json}
  end

  def search
    golinks = GoLink.member_search(params[:q], current_member)
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
    if params[:permissions]
      golink.permissions = params[:permissions]
    end
    golink.save!
    render json: golink.to_json
  end

  def destroy
    GoLink.find(params[:id]).destroy
    render nothing: true, status: 200
  end

end
