require 'rails_helper'

RSpec.describe Member, type: :model do
	before :each do 
		(0..9).each do |i|
				Member.create(name: "name#{i}",
					email: "email#{i}@gmail.com")
		end
	end
	describe 'active' do
		it 'properly gets active members' do
			expect(Member.active.length).to eq(0)
			Member.update_all(is_active: true)
			expect(Member.active.length).to eq(10)
		end
	end

	describe 'positions and roles' do
		it 'can get cms' do
			Member.first.update(committee: 'HT',position: 'cm',  is_active: true)
			expect(Member.cms.length).to eq(1)
		end
		it 'excludes GMs from cms list' do
			Member.first.update(committee:'GM', is_active: true, position: 'cm')
			expect(Member.cms.length).to eq(0)
		end
	end
end
