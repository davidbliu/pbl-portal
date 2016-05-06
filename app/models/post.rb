require 'elasticsearch/model'
class Post < ActiveRecord::Base
	has_many :post_groups, dependent: :destroy
	has_many :groups, :through => :post_groups

	def self.list(member)
		Post.order('created_at desc').where('id in (?)', Post.can_view(member))
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

	def group_string
		gs = self.groups.pluck(:name).join(', ')
		gs != '' ? gs : 'Anyone'
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
		# add to feed
	end

	def self.channels
		['CMs_and_Officers', 'Execs', 'Officers', 'CMs', 'GMs', 'David']
	end

	def gravatar
		email = self.author ? self.author : 'asdf@gmail.com'
		gravatar_id = Digest::MD5.hexdigest(email.downcase)
		return "http://gravatar.com/avatar/#{gravatar_id}.png"
	end

	def time_string
		self.created_at.strftime('%m-%d-%Y')
	end


	def self.permissions_list
		['Only Me', 'Only Execs', 'Only Officers', 'Only PBL', 'Anyone']
	end

	def self.can_access(position)
		if position == 'chair'
			return ['Only Officers', 'Only PBL', 'Anyone']
		elsif position == 'exec'
			return ['Only Execs', 'Only Officers', 'Only PBL', 'Anyone']
		elsif position == 'cm'
			return ['Only PBL', 'Anyone']
		else
			return ['Anyone']
		end
	end

	# def self.is_admin(member)
	# 	admin_emails = ['davidbliu@gmail.com', 'akwan726@gmail.com', 'nathalie.nguyen@berkeley.edu']
	# 	if member and admin_emails.include?(member.email)
	# 		return true
	# 	end
	# 	return false
	# end

	def self.feed_type
		'blog'
	end

	def words
		ActionView::Base.full_sanitizer.sanitize(self.content)
	end

	def push_list
		[]
	end

	def push(members = nil, author = nil)
		Pusher.push_post(members, self, author)
	end

	def self.feed_test
		Post.all.sample.add_to_feed([Member.david])
	end


end


