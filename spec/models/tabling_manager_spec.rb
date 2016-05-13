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
  	it 'doesnt put members into slots they cannot attend' do
  	end
  	it 'load balances slots' do
  	end
  end

end
