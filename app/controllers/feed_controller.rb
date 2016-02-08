class FeedController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def feed
		email = Member.hex_to_string(params[:token])
		items = FeedItem.feed(email)
		render json: items
	end

	def read
		email = Member.hex_to_string(params[:token])
		render json: FeedItem.read(email)
	end

	# hit this route from chrome extension
	def remove
		response = FeedResponse.where(
			feed_item_id: params[:id],
			member_email: Member.hex_to_string(params[:token]))
			.first_or_create!
		response.response_type = 'removed'
		response.save
		render nothing: true, status:200
	end

	def view_feed
		if myEmail == nil or myEmail == ''
			cookies[:auth_redirect] = '/feed/view'
			redirect_to '/auth/google_oauth2'
		else
			@me = current_member
			@email = @me.email
			@token = Member.string_to_hex(@email)
			@feed = FeedItem.full_feed(@email)
			@feed_ids = @feed.map{|x| x.id}
			@read = FeedResponse.read(@email).select{|x| @feed_ids.include?(x)}
			@removed = FeedResponse.removed(@email).select{|x| @feed_ids.include?(x)}

			# other trending stuff
			# @trending = GoLink.trending(@me).first(15)

			# pinned blogposts
			# @pinned = Post.pinned(@me)
		end
	end

	# hit this route from chrome extension
	def mark_read
		email = Member.hex_to_string(params[:token])
		response = FeedResponse.where(
			feed_item_id: params[:id],
			member_email: email
		).first_or_create!
		response.response_type  = 'read'
		response.save!
		render json: FeedItem.feed(email).length, status: 200
	end

	def push 
		response = FeedItem.find(params[:id]).push
		render json: response
	end

	def details
	end
	def destroy
		FeedItem.find(params[:id]).destroy
		render nothing: true, status: 200
	end
	def create
		item = FeedItem.create(
			title: params[:title],
			body: params[:body],
			link: params[:link],
			member_email: current_member.email,
			permissions: params[:permissions]
		)
		render nothing: true, status: 200
	end

	def details
		@responses = FeedResponse.where(feed_item_id: params[:id])
		@response_hash = @responses.index_by(&:member_email)
		@members = FeedItem.find(params[:id]).get_members.where.not(gcm_id: nil)
		@pushes = FeedPush.where(feed_item_id: params[:id])
	end

	def view_push
		push = FeedPush.find(params[:id])
		render json: push.response
	end
end
