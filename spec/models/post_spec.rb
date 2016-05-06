require 'rails_helper'

RSpec.describe Post, type: :model do
  before :each do 
  	@email1 = "m1@gmail.com"
  	@email1 = "m2@gmail.com"
  	@post1 = Post.create(author: @email1,
  		title: 'title1',
  		content: 'content1')
  	@post2 = Post.create(author: @email2,
  		title: 'title2',
  		content: 'content2')
  	@group1 = Group.create(name: 'group1')
  	@group1.group_members.create(email: @email1)
  end

  describe 'tags'

  describe 'permissions' do
  	it 'can be viewed if no group' do 
  		expect(Post.can_view(@email1).include?(@post2.id)).to eq(true)
  	end

  	it 'can be viewed by author' do
  		random_group = Group.create(name: 'random')
  		@post1.groups << random_group
  		expect(Post.can_view(@email1).include?(@post1.id)).to eq(true)
  		expect(Post.can_view(@email2).include?(@post1.id)).to eq(false)
  	end

  	it 'can be viewed if post has open group' do
  		random_group = Group.create(name: 'random', is_open: true)
  		@post1.groups << random_group
  		expect(Post.can_view(@email2).include?(@post1.id)).to eq(true)
  	end

  	it 'can be viewed by member of group and not outsider' do
  		@post2.groups << @group1
  		expect(Post.can_view(@email1).include?(@post2.id)).to eq(true)
  		expect(Post.can_view('outsider_email').include?(@post2.id)).to eq(false)
  	end
  end
end
