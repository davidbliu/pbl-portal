class GoController < ApplicationController
	skip_before_filter :verify_authenticity_token, only: [:add_checked_id, :get_checked_ids, :remove_checked_id, :test]
	before_filter :is_search
	skip_before_filter :is_signed_in #, only: [:redirect]
	
	def is_search
		if params[:q] and request.path != '/go'
			redirect_to controller:'go', action:'index', q: params[:q]
		end
	end

	def redirect
		where = GoLink.handle_redirect(params[:key], myEmail)
		if where.length == 1
			golink = where.first
			# track click
			track_click(GoLink.click_name, {:id => golink.id, :key => golink.key})
			# TODO remove reminders
			reminder_emails = Rails.cache.read('reminder_emails')
			if reminder_emails != nil and reminder_emails.include?(myEmail)
				redirect_to '/reminders?key='+golink.key
			else
				redirect_to golink.url
			end
		elsif where.length > 0
			@golinks = where
			@golinks = @golinks.paginate(:page => params[:page], :per_page => GoLink.per_page)
			@groups = Group.groups_by_email(myEmail)
			render :index
		else
			redirect_to '/go?q='+params[:key]
		end
	end

	# returns ids of selected golinks
	def get_checked_ids
		render json: GoLink.get_checked_ids(myEmail)
	end

	# return json representation of selected golinks
	def ajax_get_checked
		render json: GoLink.where('id in (?)', GoLink.get_checked_ids(myEmail)).to_json
	end


	def add_checked_id
		ids = GoLink.add_checked_id(myEmail, params[:id])
		render json: ids
	end

	def remove_checked_id
		ids = GoLink.remove_checked_id(myEmail, params[:id])
		render json: ids
	end

	def deselect_links
		GoLink.deselect_links(myEmail)
		redirect_to "/go/menu"
	end

	def index
		if params[:q].present? and params[:q].include?('http://')
			redirected = true
			redirect_to controller: 'go', action: 'add', url: params[:q]
		elsif params[:group_id] and params[:q]
			@search_term = params[:q]
			@group = Group.find(params[:group_id])
			@ajax_params = "?group_id=#{params[:group_id]}&query=#{params[:q]}"
			group_ids = @group.go_links.pluck(:id)
			@golinks = GoLink.email_search(params[:q], myEmail).where('id in (?)', group_ids)
		elsif params[:group_id]
			@group = Group.find(params[:group_id])
			@group_editing = true
			viewable = GoLink.viewable_ids(myEmail)
			@ajax_params = "?group_id=#{params[:group_id]}"
			@golinks = @group.go_links.order('created_at desc').where('go_links.id in (?)', viewable)
		elsif params[:q]
			@ajax_params = "?query=#{params[:q]}"
			@search_term = params[:q]
			@golinks = GoLink.email_search(params[:q], myEmail)
		elsif params[:selected]
			@golinks = GoLink.order('created_at desc').where('id in (?)', GoLink.get_checked_ids(myEmail))
		else
			@golinks = GoLink.list(myEmail)
		end

		# track 
		track_click("GoIndex", nil)
		
		if not redirected
			@groups = Group.groups_by_email(myEmail)
			@page = params[:page] ? params[:page].to_i : 1
			@golinks = @golinks.paginate(:page => params[:page], :per_page => GoLink.per_page)
			@golinks = @golinks.includes(:groups)
			@group_id = @group ? @group.id : -1
			render :index
		end
	end

	def ajax_scroll
		if params[:query] and params[:group_id]
			@group = Group.find(params[:group_id])
			group_ids = @group.go_links.pluck(:id)
			@golinks = GoLink.email_search(params[:query], myEmail).where('id in (?)', group_ids)
		elsif params[:query]
			@golinks = GoLink.email_search(params[:query], myEmail)
		elsif params[:group_id]
			@group = Group.find(params[:group_id])
			viewable = GoLink.viewable_ids(myEmail)
			@golinks = @group.go_links.order('created_at desc').where('go_links.id in (?)', viewable)
		else
			@golinks = GoLink.list(myEmail)
		end

		track_click("GoIndex", nil)
		
		@golinks = @golinks.paginate(:page => params[:page], :per_page => GoLink.per_page)
		@golinks = @golinks.includes(:groups)
		if @golinks.length == 0
			render nothing: true, status: 404
		else
			render 'go/ajax', layout: false
		end
	end

	def show
		@golink = GoLink.find(params[:id])
		@groups = Group.groups_by_email(myEmail)
		track_click("GoShow", {:id => @golink.id})
		render layout: false
	end


	def delete_checked
		GoLink.checked_golinks(myEmail).each{|x| x.hide}
		GoLink.deselect_links(myEmail)
		redirect_to '/go/menu'
	end

	def add
		if params[:key]
			@golinks = GoLink.where(key: params[:key]).map{|x| x.to_json}
		else
			@golinks = []
		end
		@groups = Group.groups_by_email(myEmail)
		@golink = GoLink.create(
			key: params[:key],
			url: params[:url],
			description: params[:desc],
			member_email: myEmail,
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
		golink.groups = Group.where('id in (?)', params[:groups])
		golink.save!
		golink_json = {
			key: golink.key,
			description: golink.description,
			url: golink.url,
			group_string: group_string(golink.groups)
			}.to_json
		render json: golink_json
	end

	def destroy
		GoLink.find(params[:id]).hide
		GoLink.remove_checked_id(myEmail, params[:id])
		render nothing: true, status: 200
	end

	def batch_update_groups
		add_groups = Group.where('id in (?)', params[:add])
		remove_groups = Group.where('id in (?)', params[:remove])
		remove_ids = remove_groups.pluck(:id)
		GoLink.checked_golinks(myEmail).each do |golink|
			golink.groups += add_groups
			golink.groups = golink.groups.select{|x| remove_ids.exclude?(x.id)}
			golink.groups = golink.groups.uniq
		end
		render nothing: true, status: 200
	end

	#
	# trash/restore/destroy go links
	#
	def trash 
		track_click("GoTrash", nil)
		@golinks = GoLink.deleted_list(myEmail)
	end

	def restore
		GoLink.unscoped.find(params[:id]).update(is_deleted: false)
		render nothing: true, status: 200
	end

	def destroy_copy
		GoLink.unscoped.find(params[:id]).destroy
		render nothing: true, status: 200
	end
end
