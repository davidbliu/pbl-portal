class FeedController < ApplicationController
	skip_before_filter :verify_authenticity_token


	def feed
		email = Member.hex_to_string(params[:token])
		read = FeedResponse.read(email)
		removed = FeedResponse.read(email)
		exclude = read+removed
		items = FeedItem.order('created_at DESC')
			.select{|x| not exclude.include?(x.id)}
			.map{|x| x.to_json}
		render json: items.first(10)
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
		@feed = FeedItem.all
	end

	def mark_read
		response = FeedResponse.where(
			feed_item_id: params[:id],
			member_email: Member.hex_to_string(params[:token])
		).first_or_create!
		response.response_type  = 'read'
		response.save!
		render nothing: true, status: 200
	end
end
