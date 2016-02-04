class FeedController < ApplicationController
	skip_before_filter :verify_authenticity_token


	def feed
		email = Member.hex_to_string(params[:token])
		items = FeedItem.all.map{|x| x.to_json}
		render json: items
	end

	def view_feed
		@feed = FeedItem.all
	end

	def post_response
		response = FeedResponse.where(
			feed_item_id: params[:id],
			member_email: Member.hex_to_string(params[:token])
		).first_or_create!
		response.response_type  = 'read'
		response.save!
		render nothing: true, status: 200
	end
end
