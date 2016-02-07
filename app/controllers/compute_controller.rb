class ComputeController < ApplicationController
	def trending_links
		Rails.cache.fetch('trending_links') do
			GoLink.all.first(10).to_a
		end
	end

	def pinned_posts
	end
end
