require 'rails_helper'

RSpec.describe GoLink, type: :model do
	
	before :each do
		@g1 = GoLink.create(key: 'key1', url: 'http://url1')
		@g2 = GoLink.create(key: 'key2', url: 'http://url2')

		@gp1 = Group.create(name: 'group1')
		@gp2 = Group.create(name: 'group2')

		@gp1.group_members.create(email: 'm1@gmail.com')

	end

	it 'has Anyone as default group' do
		expect(@g1.group_string).to eq("Anyone")
	end

	it 'can have single group' do 
		@g1.groups << @gp1
		expect(@g1.group_string).to eq("group1")
	end

	it 'can have multiple groups' do 
		@g1.groups << @gp1
		@g1.groups << @gp2
		expect(@g1.group_string).to eq("group1, group2")
	end

	it 'anyone can view golinks with no groups' do
		viewable = GoLink.can_view('m1@gmail.com')
		expect(viewable.length).to eq(2)
	end

	it 'group members can view golinks in groups they are part of' do
		@g1.groups << @gp1
		@g2.groups << @gp2
		viewable = GoLink.can_view('m1@gmail.com')
		expect(viewable.length).to eq(1)
	end

	it 'blocks anyone from viewing golinks if they are not in group' do
		@g1.groups << @gp2
		viewable = GoLink.can_view('m1@gmail.com')
		expect(viewable.include?(@g1.id)).to eq(false)
	end
	
	it 'can be viewed by original creator' do
		@g1.update(member_email: 'm1@gmail.com')
		@g1.groups << @gp2
		expect(GoLink.can_view("m1@gmail.com").length).to eq(2)
	end

	it 'creates a copy with the link is deleted' do 
		@g1.destroy
		expect(GoLinkCopy.all.length).to eq(1)
	end

	it 'allows members to view go links in open groups' do
		@g1.groups << @gp2
		expect(GoLink.can_view('m1@gmail.com').include?(@g1.id)).to eq(false)
		@gp2.update(is_open: true)
		expect(GoLink.can_view('m1@gmail.com').include?(@g1.id)).to eq(true)
	end

	it 'can check for matching urls' do
		matches = GoLink.url_matches(@g1.url)
		expect(matches.include?(@g1)).to eq(true)
	end

end
