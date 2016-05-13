module ApplicationHelper
	# takes enumerable of groups and makes a comma separated string
	def group_string(groups)
		if groups.length == 0
			return "Anyone"
		else
			return groups.map{|x| x.name}.join(', ')
		end
	end

	# gets name of member with this email
	# if no match, returns email
	def get_name(email)
		email_hash = Rails.cache.read('email_hash')
		if email_hash.nil?
			email_hash = Member.email_hash
			Rails.cache.write('email_hash', email_hash)
		end
		if email_hash.keys.include?(email)
			return email_hash[email].name
		else 
			return email
		end
	end

	# returns gravatar url given email
	def gravatar(email)
		if email.nil?
			email = 'asdf@gmail.com'
		end
		gravatar_id = Digest::MD5.hexdigest(email.downcase)
		return "http://gravatar.com/avatar/#{gravatar_id}.png"
	end

	#
	# formatting_times
	#

	# just date without hour
	# 	ex: 5-13-94
	def date_string(time)
		time.strftime('%m-%d-%Y')
	end

	def hour_string(time)
		time = time + Time.zone_offset("PDT")
		return time.strftime('%Y-%m-%d %H:%M:%S')
	end

end
