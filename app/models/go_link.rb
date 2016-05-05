require 'elasticsearch/model'
class GoLink < ActiveRecord::Base
	before_destroy :create_copy
	has_many :go_link_groups, dependent: :destroy
	has_many :groups, :through => :go_link_groups	
	include Elasticsearch::Model
 	include Elasticsearch::Model::Callbacks
 	GoLink.__elasticsearch__.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_HOST']

 	def self.can_view(email)
 		# if GoLink.admin_emails.include?(email)
 		# 	return GoLink.all.pluck(:id)
 		# end
 		gids = GroupMember.where(email: email).where.not(group_id: nil).pluck(:group_id)
 		gids += Group.where(is_open: true).pluck(:id)
 		ids = GoLinkGroup.where('group_id in (?)', gids).pluck(:go_link_id)
 		grouped_ids = GoLinkGroup.all.pluck(:go_link_id).uniq
 		ids += GoLink.where(member_email: email).pluck(:id)
 		ids += GoLink.where('id NOT IN (SELECT DISTINCT(go_link_id) FROM go_link_groups)').pluck(:id) 
 		return ids.uniq
 	end

	def create_copy
		if self.key.present? and self.url.present?
			copy = GoLinkCopy.create(
				key: self.key,
				url: self.url,
				member_email: self.member_email,
				description: self.description,
				golink_id: self.id)
			gps = self.groups
			gps.each do |gp|
				copy.groups << gp
			end
		end
	end

	def self.handle_redirect(key, email)
		viewable = GoLink.can_view(email)		
		where = GoLink.where(key: key).where('id in (?)', viewable)
		search_group_keys = GoPreference.search_groups(email).map{|x| x.key}
		where = where.select{|x| x.is_searchable(search_group_keys)}
		return where
	end

	def is_searchable(search_group_keys)
		true
	end

	def self.per_page
		25
	end
	def self.admin_emails
		['davidbliu@gmail.com']
	end

	def tags
		GoLinkTag.where(golink_id: self.id)
	end

	def gravatar
		email = self.member_email ? self.member_email : 'asdf@gmail.com'
		gravatar_id = Digest::MD5.hexdigest(email.downcase)
		return "http://gravatar.com/avatar/#{gravatar_id}.png"
	end

	def group_string
		if groups.length > 0
			return groups.pluck(:name).join(', ')
		else
			return 'Anyone'
		end
	end

	def to_json
		return {
	      key: self.key,
	      url: self.url,
	      description: self.description,
	      member_email: self.member_email,
	      permissions: self.permissions,
	      title: self.title,
	      num_clicks: self.num_clicks,
	      id: self.id,
	      created_at: self.created_at,
	      timestamp: self.timestamp,
	      time_string: self.time_string,
	      semester: self.semester,
	      groups: self.group_string,
	      gravatar: self.gravatar
	    }
	end

	def time_string
		self.created_at.strftime('%m-%d-%Y')
	end

	def get_num_clicks
		self.num_clicks ? self.num_clicks : 0
	end

	def link
		'http://pbl.link/'+self.key
	end

	def self.cleanup
		GoLink.where(key: 'change-this-key').destroy_all
	end

	def log_click(email)
		if self.num_clicks == nil
			self.num_clicks = 1
		else
			self.num_clicks = self.num_clicks + 1
		end
		self.save
		GoLinkClick.create(
			member_email: email,
			key: self.key,
			golink_id: self.id
		)
	end

	# TODO: bug with spreadsheets
  	def self.url_matches(url)
  		direct_matches = GoLink.where('url=? OR url=?', url.gsub('https:', 'http:'), url.gsub('http:', 'https:')).to_a
  		indirect_matches = []
		if url.include?('docs.google.com') and url.include?("/d/")
			begin
				doc_id = url.split('/d/')[1].split('/')[0]
				indirect_matches = GoLink.where('url LIKE ?', '%' + doc_id+'%').to_a
			rescue
				puts 'error'
			end
		end
		matches = direct_matches + indirect_matches
		matches = matches.uniq{|x| x.id}
		return matches
  	end

  	def self.email_search(search_term, email)
  		search = self.default_search(search_term)
  		viewable = self.can_view(email)
  		result_ids = search.select{|x| viewable.include?(x)}
		golinks_by_id = GoLink.where('id in (?)', result_ids).index_by(&:id)
		keys = golinks_by_id.keys
  		golinks = search.select{|x| golinks_by_id.keys.include?(x)}.map{|x| golinks_by_id[x]}
  		return golinks
  	end

	def self.default_search(search_term)
		q = {
			multi_match: {
				query: search_term, 
				fields: ['key^3','description','url', 'member_email'],
				fuzziness: 2
			}
		}
		results = GoLink.search(query: q, :size=>100).results
		ids = results.map{|x| x._source.id}
		return ids
	end


	def self.search_my_links(search_term, email)
		results = GoLink.search(query: {multi_match: {query: search_term, fields: ['key^3', 'description', 'text', 'url', 'member_email'], fuzziness:1}}, :size=>100).results
		return self.search_results_to_golinks(results)
	end

	#
	# Group based permissions
	#

	def self.get_checked_ids(email)
		Rails.cache.fetch("#{email}-checked") do 
			[]
		end
	end

	def self.add_checked_id(email, id)
		ids = self.get_checked_ids(email)
		ids << id
		ids = ids.uniq
		Rails.cache.write("#{email}-checked", ids)
		return ids
	end

	def self.remove_checked_id(email, id)
		ids = self.get_checked_ids(email)
		ids = ids.select{|x| x != id}
		ids = ids.uniq
		Rails.cache.write("#{email}-checked", ids)
		return ids
	end

	def self.deselect_links(email)
		Rails.cache.delete("#{email}-checked")
	end

	def self.checked_golinks(email)
		return GoLink.where('id in (?)', self.get_checked_ids(email))
	end


end
