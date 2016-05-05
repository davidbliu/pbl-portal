require 'rails_helper'

RSpec.describe GoLinkCopy, type: :model do
	before :each do 
		@golink1 = GoLink.create(key: 'key1', 
			url: 'http://url', 
			member_email: 'm1@gmail.com',
			description: 'description1'
		)
		@group1 = Group.create(name: 'group1')
		@golink1.groups << @group1
	end
	it 'gets created when golink destroyed' do
		@golink1.destroy
		expect(GoLinkCopy.all.length).to eq(1)
	end

	it 'inherits golinks attributes' do 
		@golink1.destroy
		@copy = GoLinkCopy.first
		expect(@copy.key).to eq('key1')
		expect(@copy.url).to eq('http://url')
		expect(@copy.member_email).to eq('m1@gmail.com')
		expect(@copy.description).to eq('description1')
	end

	it 'gets groups when there are no groups' do
		gl = GoLink.create(key: 'k', url: 'http://u')
		gl.destroy
		expect(GoLinkCopy.find_by_key('k').groups.length).to eq(0)
	end
	
	it 'gets the golinks groups when there is 1 group' do
		expect(@golink1.groups.length).to eq(1)
		@golink1.destroy
		@copy = GoLinkCopy.first 
		expect(@copy.groups.length).to eq(1)
	end

	it 'can restore golink' do
		@golink1.destroy
		GoLinkCopy.first.restore
		expect(GoLinkCopy.all.length).to eq(0)
		expect(GoLink.where(key: 'key1').length).to eq(1)
	end
end
