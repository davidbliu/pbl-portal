require 'rails_helper'

RSpec.describe GoController, type: :controller do
	render_views
	before :each do 
		@email1 = 'm1@gmail.com'
		@email2 = 'm2@gmail.com'
		request.cookies['email'] = 'm1@gmail.com'
		@url1 = 'http://google.com'
		@url2 = 'http://google2.com'
		@gl1 = GoLink.create(url: @url1, key: 'key1', member_email: @email1)
		@gl2 = GoLink.create(url: @url2, key: 'key2', member_email: @email2)
		@gl3 = GoLink.create(url: @url2, key: 'key3', member_email: @email2)
		@group1 = Group.create(creator: @email2, name: 'group1')
		@gl3.groups << @group1
	end
	it 'redirects to golink' do
		get :redirect, {:key => 'key1'}
		expect(response).to redirect_to(@url1)
	end

	it 'redirects to golink for links with no group' do 
		get :redirect, {:key => 'key2'}
		expect(response).to redirect_to(@url2)
	end

	it 'redirects to home page for links you dont have permission to' do
		get :redirect, {:key => 'key3'}
		expect(response).to redirect_to('/go?q=key3')
	end

	it 'shows a landing page if duplicate keys' do
		GoLink.create(key: 'key1', url: 'http://google3.com')
		get :redirect, {:key => 'key1'}
		expect(response).to render_template(:new_index)
	end
end
