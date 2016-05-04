require 'rails_helper'

RSpec.describe GoLink, type: :model do
  before :each do 
    @g1 = GoLink.create(key: 'something', url: 'random url', groups: '')
  end
  it 'has a valid key' do 
    puts @g1.key
    puts 'lol?'
  end

end
