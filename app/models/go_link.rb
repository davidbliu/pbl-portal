require 'elasticsearch/model'
class GoLink < ActiveRecord::Base
	include Elasticsearch::Model
 	include Elasticsearch::Model::Callbacks
 	GoLink.__elasticsearch__.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_HOST']
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
	      groups: self.groups
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

	# def self.permissions_list
	# 	['Only Me', 'Only Execs', 'Only Officers', 'Only PBL', 'Anyone']
	# end

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


  	def self.member_search(search_term, member)
  		search = self.default_search(search_term)
  		viewable = self.can_view(member.email)
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
		results = GoLink.search(query: {multi_match: {query: search_term, fields: ['key^3', 'tags^2', 'description', 'text', 'url', 'member_email'], fuzziness:1}}, :size=>100).results
		return self.search_results_to_golinks(results)
	end

	#
	# Group based permissions
	#

	def get_groups
		self.groups.split(',').map{|x| x.strip}
	end

	def self.can_view(email)
		groups = Member.groups(email)
		ids = []
		groups.each do |group|
			ids += self.get_group_links(group).pluck(:id)
			# ids += GoLink.where('groups like ?', "%#{group.key}%").pluck(:id)
		end
		ids += GoLink.where('groups like ?', "%Anyone%").pluck(:id)
		ids += GoLink.where('groups like ? and member_email = ?', "%Only Me%", email).pluck(:id)
		return ids.uniq
	end

	def self.get_groups_by_email(email)
		groups = Member.groups(email)
    	groups << Group.new(key: 'Only Me', name: 'Only Me')
	end

	def self.default_groups(email)
		return "Anyone"
	end

	def self.get_group_links(group)
		GoLink.where('groups like ?', "%#{group.key}%")
	end

	

end
