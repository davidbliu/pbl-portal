class FeedController < ApplicationController
	skip_before_filter :verify_authenticity_token


	def feed
		email = Member.hex_to_string(params[:token])
		items = FeedItem.feed(email)
		render json: items
	end

	def read
		email = Member.hex_to_string(params[:token])
		read = FeedResponse.read(email)
		items = FeedItem.order('created_at DESC')
			.where('id in (?)', read)
			.map{|x| x.to_json}
		render json: items
	end

	def remove
		response = FeedResponse.where(
			feed_item_id: params[:id],
			member_email: Member.hex_to_string(params[:token]))
			.first_or_create!
		response.response_type = 'removed'
		response.save
		render nothing: true, status:200
	end

	def new
	end

	def create
	end

	def view_feed
		@feed = FeedItem.full_feed(current_member.email)
	end

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
		# redirect_to 'feed/view'
		render nothing: true, status: 200
	end
	def create
		item = FeedItem.create(
			title: params[:title],
			body: params[:body],
			link: params[:link],
			member_email: current_member.email)
		item.push
		render nothing: true, status: 200
	end
	def details
		@responses = FeedResponse.where(feed_item_id: params[:id])
	end
end
