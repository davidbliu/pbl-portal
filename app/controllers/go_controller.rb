class GoController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:add_checked_id, :get_checked_ids, :remove_checked_id, :test]
  def redirect
    if params[:key].include?('wiki:')
      term = params[:key].split(':')[1]
      redirect_to 'http://wd.berkeley-pbl.com/wiki/index.php/Special:Search/'+term 
    else
      viewable = GoLink.can_view(myEmail)
      golink = GoLink.where(key: params[:key])
        .where('id in (?)', viewable)
      if golink.length > 1
        @golinks = golink
        @golinks = @golinks.map{|x| x.to_json}
        @groups = GoLink.get_groups_by_email(myEmail)
        @golinks = @golinks.paginate(:page => params[:page], :per_page => 10)
        render :new_index
      elsif golink.length == 1
        golink = golink.first
        # log this
        Thread.new{
          golink.log_click(myEmail)
          ActiveRecord::Base.connection.close
        }
        reminder_emails = Rails.cache.read('reminder_emails')
        if reminder_emails != nil and reminder_emails.include?(myEmail)
          redirect_to '/reminders?key='+golink.key
        else
          redirect_to golink.url
        end
      else
      	# do a search
        redirect_to '/go?q='+params[:key]
      end
    end
  end

  def get_checked_ids
    render json: GoLink.get_checked_ids(myEmail)
  end

  def test
    session[:test] ||= []
    session[:test] << params[:p]
    render json: session[:test]
  end

  def add_checked_id
    ids = GoLink.add_checked_id(myEmail, params[:id])
    render json: ids
  end

  def remove_checked_id
    ids = GoLink.remove_checked_id(myEmail, params[:id])
    render json: ids
  end

  def checked_links
    @golinks = GoLink.where('id in (?)', GoLink.get_checked_ids(myEmail))
    @golinks = @golinks.map{|x| x.to_json}
    @golinks = @golinks.paginate(:page => params[:page], :per_page => 10)
    @groups = Group.groups_by_email(myEmail)
    @batch_editing = true
    @group = Group.new(name: 'Batch Edit Links')
    render :new_index
  end

  def deselect_links
    GoLink.deselect_links(myEmail)
    redirect_to '/go'
  end

  def index2
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @group_editing = true
      viewable = GoLink.can_view(myEmail)
      @golinks = @group.golinks.where('id in (?)', viewable)
      @golinks = @golinks.map{|x| x.to_json}
    elsif params[:q]
      if params[:q].include?('http://') or params[:q].include?('https://')
        redirected = true
        redirect_to controller: 'go', action: 'add', url: params[:q]
      end
      @search_term = params[:q]
      @golinks = GoLink.email_search(params[:q], myEmail)
      @golinks = @golinks.map{|x| x.to_json}
    else
      viewable = GoLink.can_view(myEmail)
      @golinks = GoLink.order('created_at desc')
        .where('id in (?)',viewable)
        .where.not(key: 'change-this-key')
        .map{|x| x.to_json}
    end
    @groups = Group.groups_by_email(myEmail)
    @golinks = @golinks.paginate(:page => params[:page], :per_page => 25)
    if not redirected
      render :new_index
    end
  end

  def show
    @golink = GoLink.find(params[:id])
    @groups = Group.groups_by_email(myEmail)
    render layout: false
  end

  def batch_show
    @groups = Group.groups_by_email(myEmail)
    @golinks = GoLink.where('id in (?)', params[:ids])
    render layout: false
  end

  def batch_delete2
    GoLink.where('id in (?)', params[:ids]).destroy_all
    render nothing: true, status: 200
  end

  def delete_checked
    GoLink.checked_golinks(myEmail).destroy_all
    GoLink.deselect_links(myEmail)
    redirect_to '/go'
  end

  def index
    if params[:q]
      @golinks = GoLink.email_search(params[:q], myEmail)
    else
      viewable = GoLink.can_view(myEmail)
    	@golinks = GoLink.order('created_at desc')
        .where('id in (?)',viewable)
        .where.not(key: 'change-this-key')
        .map{|x| x.to_json}
    end
    # paginate golinks
    @golinks = @golinks.paginate(:page => params[:page], :per_page => 100)
    @groups = GoLink.get_groups_by_email(myEmail)
    @tags = params[:q] ? [] : GoTag.all 
    @pinned = @tags.select{|x| x.name == 'Pinned'}#where(name:'Pinned')
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

  def admin
    @keys = GoLinkClick.all.pluck(:key).uniq
    @groups = Member.groups
  end

  def engagement
    keys = params[:keys] ? params[:keys].split(',') : []
    @keys = keys
    clicks = GoLinkClick.order('created_at DESC')
        .where.not(member_email:'davidbliu@gmail.com')
    if keys != []
      clicks = clicks.where('key in (?)', keys)
    end
    if params[:time] and params[:time] != ''
      time = Time.parse(params[:time])
      @time = time
      clicks = clicks.where('created_at > ?', time)
    end
    if params[:group] and params[:group] != ''
      @members = Member.get_group(params[:group]).order(:committee)
    else
      @members = Member.current_members
        .where.not(committee:'GM')
        .where.not(email:'davidbliu@gmail.com')
        .order(:committee)
    end

    @click_hash = {}
    seen = []
    @members.each do |m|
      @click_hash[m.email] = []
      seen << m.email
    end
    clicks.each do |click|
      if not seen.include?(click.member_email)
        @click_hash[click.member_email] = []
        seen << click.member_email
      else
        @click_hash[click.member_email] << click
      end
    end  

    @inactive = []
    @active = []
    @members.each do |m|
      if not @click_hash[m.email] or @click_hash[m.email].length ==0
        @inactive << m
      else
        @active << m
      end
    end


  end


  def add
    if params[:key]
      @golinks = GoLink.where(key: params[:key]).map{|x| x.to_json}
    else
      @golinks = []
    end
    @groups = Group.groups_by_email(myEmail)

    group_keys = @groups.map{|x| x.key}
    group_keys = group_keys.length > 0 ? group_keys.join(',') : 'Anyone'
    @golink = GoLink.create(
      key: params[:key],
      url: params[:url],
      member_email: myEmail,
      groups: 'Anyone',
      member_email: myEmail
    )
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
    golinks = GoLink.email_search(params[:q], email)
    render json: golinks.map{|x| x.to_json}
  end



  def update
    golink = GoLink.find(params[:id])
    if params[:title]
      golink.title = params[:title].strip
    end
    if params[:key]
      golink.key = params[:key].strip
    end
    if params[:url]
      golink.url = params[:url].strip
    end
    if params[:description]
      golink.description = params[:description].strip
    end
    if params[:permissions]
      golink.permissions = params[:permissions].strip
    end
    if params[:groups]
      golink.groups = Group.process_groups(params[:groups])
    end
    golink.save!
    render json: golink.to_json
  end

  def destroy
    GoLink.find(params[:id]).destroy
    render nothing: true, status: 200
  end

  def three_days
    @three_past = 3.days.ago
    @clicks = GoLinkClick.where('created_at > ?', @three_past)
  end

  def time_distribution
    @clicks = GoLinkClick.all
    @bins = Array.new(24, 0)
    @hours = (0..24).to_a
    @num = 0
    @clicks.each do |click|
      hour = click.created_at.in_time_zone("Pacific Time (US & Canada)").hour
      @bins[hour] = @bins[hour]+1
    end
    @golinks = GoLink.where(semester: Semester.current_semester)
    @num_clicks = @golinks.map{|x| x.get_num_clicks}
    @max = @num_clicks.max 
    @min = @num_clicks.min
    @avg = @num_clicks.mean
    @std = @num_clicks.standard_deviation
    @click_bins = Array.new(15, 0)
  end

  def batch_delete
    ids = JSON.parse(params[:ids])
    ids.each do |id|
      GoLink.find(id).destroy
    end
    redirect_to :back
  end

  def batch_edit
    ids = JSON.parse(params[:ids])
    @golinks = GoLink.where('id in (?)', ids)
    @groups = GoLink.get_groups_by_email(myEmail)
    @tags = GoTag.all
  end

  def batch_update_groups
    add_groups = Group.where('id in (?)', params[:add])
    remove_groups = Group.where('id in (?)', params[:remove])
    GoLink.checked_golinks(myEmail).each do |golink|
      golink.add_groups(add_groups)
      golink.remove_groups(remove_groups)
    end
    render nothing: true, status: 200
  end

  def batch_update_tags
    golinks = GoLink.where('id in (?)', params[:ids])
    tags = params[:tags] ? params[:tags] : []
    action_type = params[:atype]
    golinks.each do |golink|
      tags.each do |tag|
        if action_type == 'add'
          GoLinkTag.where(
            golink_id: golink.id,
            tag_name: tag
          ).first_or_create
        elsif action_type == 'remove'
          GoLinkTag.where(
            golink_id: golink.id,
            tag_name: tag
          ).destroy_all
        end
      end
    end
    render nothing: true, status: 200
  end

end




