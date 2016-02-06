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
	      time_string: self.created_at.strftime('%m-%d-%Y'),
	      semester:self.semester
	    }
	end

	def self.permissions_list
		['Only Me', 'Only Execs', 'Only Officers', 'Only PBL', 'Anyone']
	end

	def self.cleanup
		GoLink.where(key: 'change-this-key').destroy_all
	end


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
  		viewable = self.can_view(member)
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

	def get_permissions
		(self.permissions and self.permissions != '') ? self.permissions : 'Anyone'
	end

	# get all links that a member can view
	def self.can_view(member)
		semesters = Semester.past_semesters
		viewable = []
		viewable = GoLink.where('member_email = ? OR semester = ? OR permissions = ? OR permissions IS NULL',
			member.email,
			nil,
			'Anyone'
		).pluck(:id)
		positions = Position.where(member_email: member.email)
		positions.each do |position|
			pos = position.position
			golink_ids = GoLink.where(semester: position.semester)
				.where('permissions in (?)',
				 Post.can_access(pos)
			).pluck(:id)
			viewable = viewable + golink_ids
		end
		return viewable.uniq
	end
	# verify viewable for a single golink
	def can_view(member)
		if self.semester != Semester.current_semester
			if member == nil
				pos = nil
			else
				pos = Position.where(member_email:member.email).first
			end
			if pos == nil
				return self.get_permissions == 'Anyone'
			elsif self.get_permissions == 'Anyone'
				return true
			elsif self.get_permissions == 'Only PBL'
				return (member and member.email != nil and member.email != '')
			elsif self.get_permissions == 'Only Officers'
				return (pos.position == 'chair' or pos.position == 'exec')
			elsif self.get_permissions == 'Only Execs'
				return pos.position == 'exec'
			elsif self.member_email == member.email
				return true
			end

		else
			# use this if current semester
			if member == nil
				return self.get_permissions == 'Anyone'
			elsif self.get_permissions == 'Anyone'
				return true
			elsif self.get_permissions == 'Only PBL'
				return (member and member.email != nil and member.email != '')
			elsif self.get_permissions == 'Only Officers'
				return (member and member.position != nil and (member.position == 'chair' or member.position == 'exec'))
			elsif self.get_permissions == 'Only Execs'
				return (member and member.position != nil and member.position == 'exec')
			elsif self.get_permissions == 'Only My Committee'
				return true
			elsif self.member_email == member.email
				return true
			end
		end
	end

end
