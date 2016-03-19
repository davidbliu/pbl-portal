class GoController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:add_checked_id, :get_checked_ids, :remove_checked_id, :test]
  before_filter :is_search

  def is_search
    if params[:q] and request.path != '/go'
      redirect_to controller:'go', action:'index', q: params[:q]
    end
  end

  def redirect
    where = GoLink.handle_redirect(params[:key], myEmail)
    if where.length == 1
      golink = where.first
      Thread.new{
        golink.log_click(myEmail)
        ActiveRecord::Base.connection.close
      }
      # TODO remove reminders
      reminder_emails = Rails.cache.read('reminder_emails')
      if reminder_emails != nil and reminder_emails.include?(myEmail)
        redirect_to '/reminders?key='+golink.key
      else
        redirect_to golink.url
      end
    elsif where.length > 0
      @golinks = where
      @golinks = @golinks.map{|x| x.to_json}
      @golinks = @golinks.paginate(:page => params[:page], :per_page => GoLink.per_page)
      @groups = GoLink.get_groups_by_email(myEmail)
      render :new_index
    else
      redirect_to '/go?q='+params[:key]
    end
  end

  def get_checked_ids
    render json: GoLink.get_checked_ids(myEmail)
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
    @golinks = @golinks.paginate(:page => params[:page], :per_page => GoLink.per_page)
    @groups = Group.groups_by_email(myEmail)
    @batch_editing = true
    @group = Group.new(name: 'Batch Edit Links')
    render :new_index
  end

  def deselect_links
    GoLink.deselect_links(myEmail)
    redirect_to :back
  end

  def index
    # handle landing group
    if not request.path == '/go/menu' and not params[:group_id]
      landing_group = GoPreference.landing_group(myEmail)
      if landing_group
        redirected = true
        redirect_to "/go?group_id=#{landing_group.id}" 
      end
    end
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
    @golinks = @golinks.paginate(:page => params[:page], :per_page => GoLink.per_page)
    if not redirected
      render :new_index
    end
  end

  def show
    @golink = GoLink.find(params[:id])
    @groups = Group.groups_by_email(myEmail)
    render layout: false
  end


  def delete_checked
    GoLink.checked_golinks(myEmail).destroy_all
    GoLink.deselect_links(myEmail)
    redirect_to '/go'
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


  def add
    if params[:key]
      @golinks = GoLink.where(key: params[:key]).map{|x| x.to_json}
    else
      @golinks = []
    end
    @groups = Group.groups_by_email(myEmail)
    @default_groups = GoPreference.default_groups(myEmail)
    @default_keys = @default_groups.map{|x| x.key}
    @default_ids = @default_groups.map{|x| x.id}
    @golink = GoLink.create(
      key: params[:key],
      url: params[:url],
      description: params[:desc],
      member_email: myEmail,
      groups: @default_keys.join(','),
      member_email: myEmail
    )
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
    params[:groups] ||= []
    golink.groups = params[:groups].join(',')
    golink.save!
    render json: golink.to_json
  end

  def destroy
    GoLink.find(params[:id]).destroy
    render nothing: true, status: 200
  end

 

  def batch_delete
    ids = JSON.parse(params[:ids])
    ids.each do |id|
      GoLink.find(id).destroy
    end
    redirect_to :back
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
  
  def preferences
    @landing_group_id = GoPreference.landing_group_id(myEmail)
    @default_group_ids = GoPreference.default_group_ids(myEmail)
    @search_group_ids = GoPreference.search_group_ids(myEmail)
    @groups = Group.groups_by_email(myEmail)
  end
  def update_preferences
    GoPreference.set_default_group_ids(myEmail, params[:default_groups])
    GoPreference.set_search_group_ids(myEmail, params[:search_groups])
    GoPreference.set_landing_group_id(myEmail, params[:landing_group_id])
    render nothing: true, status: 200
  end

#
# TODO: move to reporting controller
#

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

end




