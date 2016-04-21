class Topic < ActiveRecord::Base
	def self.random_topic
		min = Topic.select(:count).map(&:count).min
		topic = Topic.where(count: min).sample
		topic.count = topic.count.to_i+1
		topic.save!
		return topic.body
	end
	def self.init
		File.open('topics.txt', 'r') do |f|
			lines = []
			f.each_line do |line|
				line = line.strip
				t = Topic.where(body: line).first_or_create!
				t.count = 0
				t.save
			end
		end
	end
end
