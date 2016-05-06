require 'rails_helper'

RSpec.describe BlogController, type: :controller do
	before :each do 
		@email1 = "m1@gmail.com"
		@group1 = Group.create(name: 'group1')
		request.cookies[:email] = @email1

		@post1 = Post.create(title: 'post1', content: 'content1', author: @email1)
	end
	describe 'editing' do
		it 'can save a new link' do
			num_posts = Post.all.length
			post :save, {title: 'new_title', content: 'new_content', group_ids: "#{@group1.id}"}
			expect(Post.all.length).to eq(1+num_posts)
		end
		it 'can save an existing link' do 
			post :save, {title: 'post1edited', content: 'new_content', id: @post1.id}
			expect(Post.where(title: 'post1edited').length).to eq(1)
		end
	end
end
