require 'elasticsearch/model'
class GoLink < ActiveRecord::Base

	before_save :fix_groups
	include Elasticsearch::Model
 	include Elasticsearch::Model::Callbacks
 	GoLink.__elasticsearch__.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_HOST']
	
	def fix_groups
		gps = self.groups.split(',').map{|x| x.strip}
		gps = gps.select{|x| x != '' and x != 'Anyone'}.uniq
		gps = gps.join(',')
		if gps == ''
			gps = 'Anyone'
		end
		self.groups = gps
	end
	def self.admin_emails
		['davidbliu@gmail.com']
	end

	def tags
		GoLinkTag.where(golink_id: self.id)
	end

	def creator_gravatar
		email = self.member_email ? self.member_email : 'asdf@gmail.com'
		gravatar_id = Digest::MD5.hexdigest(email.downcase)
		return "http://gravatar.com/avatar/#{gravatar_id}.png"
	end

	def to_json
		return {
	      key: self.key,
	      url: self.url,
	      description: self.description,
	      member_email:  self.member_email,
	      permissions: self.permissions,
	      title: self.title,
	      num_clicks: self.num_clicks,
	      id: self.id,
	      created_at: self.created_at,
	      timestamp: self.timestamp,
	      time_string: self.time_string,
	      semester:self.semester,
	      groups: self.groups,
	      gravatar: self.creator_gravatar
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

	def get_groups
		self.groups.split(',').map{|x| x.strip}
	end

	def self.can_view(email)
		if GoLink.admin_emails.include?(email)
			return GoLink.all.pluck(:id)
		end
		groups = Group.groups_by_email(email)
		ids = []
		groups.each do |group|
			ids += group.golinks.pluck(:id)
		end
		ids += GoLink.where('groups like ?', "%Anyone%").pluck(:id)
		ids += GoLink.where(member_email: email).pluck(:id)
		return ids.uniq
	end

	def self.get_groups_by_email(email)
		groups = Group.groups_by_email(email)
    	groups << Group.new(key: 'Only Me', name: 'Only Me')
	end


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
	
	def add_groups(groups)
		group_keys = self.groups.split(',')
		group_keys = group_keys.concat(groups.map{|x| x.key}).join(',')
		self.groups = group_keys
		self.save
	end

	def remove_groups(groups)
		group_keys = self.groups.split(',')
		remove_keys = groups.map{|x| x.key}
		group_keys = group_keys.select{|x| not remove_keys.include?(x)}.join(',')
		self.groups = group_keys
		self.save
	end

end
