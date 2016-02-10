class GoController < ApplicationController
  def redirect
    # must have an email to use pbl links
    if myEmail == nil or myEmail == ''
      cookies[:auth_redirect] = '/'+params[:key]+'/go'
      redirect_to '/auth/google_oauth2'
    else
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
          # redirect_to golink.first.url
          golink = golink.first
          # log this
          Thread.new{
            golink.log_click(myEmail)
            ActiveRecord::Base.connection.close
          }
          redirect_to golink.url
        else
        	# do a search
          redirect_to '/go?q='+params[:key]
        end
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

  def insights
    @clicks = GoLinkClick.where(golink_id: params[:id])
      .where.not(member_email:'davidbliu@gmail.com').to_a
    @members = Member.current_members.where.not(committee: 'GM').to_a
  end


  def recent
    @recent = GoLinkClick.order('created_at DESC')
      .where.not(member_email: 'davidbliu@gmail.com')
      .first(1000)
    @email_hash = Member.email_hash
  end

  def engagement
    @members = Member.current_members
      .where.not(committee:'GM')
      .where.not(email:'davidbliu@gmail.com')
      .order('committee')
    @click_hash = {}
    seen = []
    @members.each do |m|
      @click_hash[m.email] = []
      seen << m.email
    end
    clicks = GoLinkClick.order('created_at DESC').all.to_a
    clicks.each do |click|
      if not seen.include?(click.member_email)
        @click_hash[click.member_email] = []
        seen << click.member_email
      else
        @click_hash[click.member_email] << click
      end
    end
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
