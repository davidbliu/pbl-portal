require 'elasticsearch/model'
class Post < ActiveRecord::Base
	has_many :post_groups, dependent: :destroy
	has_many :groups, :through => :post_groups
	has_many :post_comments

	include Elasticsearch::Model
 	include Elasticsearch::Model::Callbacks
 	Post.__elasticsearch__.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_HOST']

	def self.email_search(email, search_term)
		q = {
			multi_match: {
				query: search_term, 
				fields: ['title^3','content', 'author'],
				fuzziness: 1
			}
		}
		viewable_ids = self.can_view(email)
		result_ids = Post.search(query: q, :size => 100).results.map{|x| x._source.id}
		return Post.includes(:groups).where('id in (?)', result_ids & viewable_ids).sort_by{|x| result_ids.index(x)} 
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


