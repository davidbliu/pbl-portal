require 'rails_helper'

RSpec.describe GoController, type: :controller do
	render_views
	before :each do 
		@email1 = 'm1@gmail.com'
		@email2 = 'm2@gmail.com'
		request.cookies['email'] = @email1
		@url1 = 'http://google.com'
		@url2 = 'http://google2.com'
		@gl1 = GoLink.create(url: @url1, key: 'key1', description: 'desc1', member_email: @email1)
		@gl2 = GoLink.create(url: @url2, key: 'key2', description: 'desc2',  member_email: @email2)
		@gl3 = GoLink.create(url: @url2, key: 'key3', description: 'desc3',  member_email: @email2)

		# email1 is NOT part of this group
		@group1 = Group.create(creator: @email2, name: 'group1')
		@gl3.groups << @group1

		# email 1 IS part of group
		@group2 = Group.create(creator: @email1, name: 'group2', is_open: true)
	end

	describe 'groups' do
		it 'has Anyone as default group string' do
			get :index
			expect(response.body).to include('Anyone')
		end
	end

	describe 'adding' do
		it 'can add links from home page with search' do
			url = "http://random_url.com"
			get :index, {q: url}
			expect(response).to redirect_to({:action => :add, :url => url})
		end

		it 'can add links from extension' do
			url = 'http://random_url.com'
			desc = 'asdfasdf'
			key = 'ranlsakfjlsdjf'
			get :add, {url: url, key: key, desc: desc}
			expect(GoLink.find_by_url(url).nil?).to eq(false)
			expect(GoLink.find_by_key(key).nil?).to eq(false)
			expect(GoLink.find_by_description(desc).nil?).to eq(false)
		end
	end

	describe 'redirect action' do
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
			expect(response).to render_template(:index)
		end
	end

	describe 'updating golink' do
		it 'updates url, description, key' do
			post :update, {id: @gl1.id, key: 'newkey', description: 'desc', url: 'http://urlbad'}
			expect(GoLink.where(key: 'newkey').length).to eq(1)
			expect(GoLink.where(description: 'desc').length).to eq(1)
			expect(GoLink.where(url: 'http://urlbad').length).to eq(1)
		end

		it 'updates groups' do
			post :update, {groups: [@group1.id], id: @gl1.id}
			expect(@gl1.groups.length).to eq(1)
		end
	end

	describe 'search' do
		it 'returns search results for exact key queries' do
		end

		it 'scopes search queries' do
		end
	end

	describe 'batch editing' do
		it 'can select and deselect links' do
			post :add_checked_id, {id: @gl1.id}
			get :index, {selected: true}
			expect(response.body).to include("key1")
			expect(response.body).not_to include("key2")
			post :remove_checked_id, {id: @gl1.id}
			expect(response.body).not_to include('key1')
		end

		it 'can deselect all links' do
			get :deselect_links
			post :add_checked_id, {id: @gl1.id}
			post :add_checked_id, {id: @gl2.id}
			expect(GoLink.get_checked_ids(@email1).length).to eq(2)
			get :deselect_links
			expect(GoLink.get_checked_ids(@email1).length).to eq(0)
		end

		it 'can get checked ids' do
			get :deselect_links
			post :add_checked_id, {id: @gl1.id}
			get :get_checked_ids
			expect(response.body).to include(@gl1.id.to_s)
		end

		it 'can batch delete links' do
			get :deselect_links
			post :add_checked_id, {id: @gl1.id}
			get :delete_checked
			expect(GoLink.where(key: 'key1').length).to eq(0)
		end

		it 'can batch add and delete groups' do
			post :add_checked_id, {id: @gl1.id}
			params = {add: [@group2.id]}
			post :batch_update_groups, params
			expect(@gl1.groups.include?(@group2)).to eq(true)

			delete_params = {remove: [@group2.id]}
			post :batch_update_groups, delete_params
			expect(@gl1.groups.include?(@group2)).to eq(false)
		end
	end

	describe 'main page with parameters' do
		it 'can restrict groups' do
			request.cookies[:email]=@email2
			get :index, {group_id: @group1.id}
			expect(response.body).to include('key3')
			expect(response.body).to_not include('key1')
		end

		# it 'can search' do 
			# get :index, {q: 'key1'}
			# expect(response.body).to include('key1')
		# end
	end

	describe 'show' do
		it 'can show golink' do
			get :show, {id: @gl1.id}
			expect(response.body).to include('key1')
		end
	end


end
