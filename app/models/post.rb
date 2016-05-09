require 'elasticsearch/model'
class Post < ActiveRecord::Base
	has_many :post_groups, dependent: :destroy
	has_many :groups, :through => :post_groups
	has_many :post_comments

	def self.search(q)
		search_regex = "%#{q.downcase}%"
		Post.where('lower(title) LIKE ? 
			OR lower(content) LIKE ? OR
			lower(author) like ?', 
			search_regex,
			search_regex,
			search_regex)
	end

	def comments
		return self.post_comments
	end

	# returns ids of posts this email can view
	def self.can_view(email)
		gids = GroupMember.where(email: email).where.not(group_id: nil).pluck(:group_id)
		gids += Group.where(is_open: true).pluck(:id)
		ids = PostGroup.where('group_id in (?)', gids).pluck(:post_id)
		ids += Post.where('id NOT IN (SELECT DISTINCT(post_id) FROM post_groups)').pluck(:id)
		ids += Post.where(author: email).pluck(:id)
		return ids.uniq
	end

	def self.channel_to_emails(channel)
		email_dict = {}
		email_dict['GMs'] = 'berkeley-pbl-spring-2016-general-members@googlegroups.com'
		email_dict['CMs'] ='berkeley-pbl-spring-2016-committee-members@googlegroups.com'
		email_dict['CMs_and_Officers'] = 'berkeleypblcommittees@lists.berkeley.edu'
		email_dict['Officers'] = 'berkeleypblofficers@lists.berkeley.edu'
		email_dict['Execs'] = 'berkeleypblexecs@lists.berkeley.edu'
		email_dict['David'] =  'davidbliu@gmail.com'
		return email_dict[channel]
	end

	def send_mail(channel)
		BlogMailer.mail_post(Post.channel_to_emails(channel), self).deliver
	end

	def self.channels
		['CMs_and_Officers', 'Execs', 'Officers', 'CMs', 'GMs']
	end

	def time_string
		self.created_at.strftime('%m-%d-%Y')
	end

	def push_list
		if self.groups.length == 0
			return Member.all
		elsif self.groups.pluck(:is_open).include?(true)
			return Member.all
		else
			emails = GroupMember.where('group_id in (?)', self.groups.pluck(:id)).pluck(:email)
			return Member.where('email in (?)', emails)
		end
	end

	def push(members = nil, author = nil)
		Pusher.push_post(members, self, author)
	end

end


