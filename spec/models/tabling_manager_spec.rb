require 'rails_helper'

RSpec.describe TablingManager, type: :model do
  before :each do 
  	(1..100).each do |i|
  		Member.create(
  			name: "member#{i}",
  			email: "member#{i}@gmail.com")
  	end
  end

  describe 'generating' do

    it 'only generates all slots, but empty if no current members' do
      TablingManager.gen_tabling
      # slots create
      expect(TablingSlot.all.length).to eq(TablingManager.default_slots.length)
      expect(TablingSlot.all.select{|x| x.member_emails.length > 0}.length).to eq(0)
    end
  	it 'doesnt put members into slots they cannot attend' do

  	end
  	it 'load balances slots' do
  	end
  end

end
