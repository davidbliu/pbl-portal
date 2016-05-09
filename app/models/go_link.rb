require 'elasticsearch/model'
class GoLink < ActiveRecord::Base
	before_destroy :create_copy
	has_many :go_link_groups, dependent: :destroy
	has_many :groups, :through => :go_link_groups	
	include Elasticsearch::Model
 	include Elasticsearch::Model::Callbacks
 	GoLink.__elasticsearch__.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_HOST']

 	def self.list(email)
 		if GoLink.admin_emails.include?(email)
 			return GoLink.order('created_at desc')
 		end
 		gids = GroupMember.where(email: email).where.not(group_id: nil).pluck(:group_id)
 		gids += Group.where(is_open: true).pluck(:id)
 		golinks = GoLink.order('created_at desc').where('member_email = ? OR id NOT IN (SELECT DISTINCT(go_link_id) FROM go_link_groups) OR id in (?)', email, GoLinkGroup.where('group_id in (?)', gids).pluck(:go_link_id))
 		return golinks
 	end

 	# return list of golinks
 	def self.viewable_ids(email)
 		if GoLink.admin_emails.include?(email)
 			return GoLink.all.pluck(:id)
 		end
 		gids = GroupMember.where(email: email).where.not(group_id: nil).pluck(:group_id)
 		gids += Group.where(is_open: true).pluck(:id)
 		ids = GoLinkGroup.where('group_id in (?)', gids).pluck(:go_link_id)
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
		viewable = GoLink.viewable_ids(email)		
		where = GoLink.where(key: key).where('id in (?)', viewable)
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

	def group_string
		if groups.length > 0
			return groups.pluck(:name).join(', ')
		else
			return 'Anyone'
		end
	end
	
	def time_string
		self.created_at.strftime('%m-%d-%Y')
	end

	def get_num_clicks
		self.num_clicks ? self.num_clicks : 0
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

  	# returns list of golinks
  	def self.email_search(search_term, email)
  		search = self.default_search(search_term)
  		viewable = self.viewable_ids(email)
  		return GoLink.where('id in (?)', search & viewable)
  		# result_ids = search.select{|x| viewable.include?(x)}
		# golinks_by_id = GoLink.where('id in (?)', result_ids).index_by(&:id)
		# keys = golinks_by_id.keys
  		# golinks = search.select{|x| golinks_by_id.keys.include?(x)}.map{|x| golinks_by_id[x]}
  		return golinks
  	end

  	# returns list of ids
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

	#
	# batch checking
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
