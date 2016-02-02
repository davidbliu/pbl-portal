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
	      time_string: self.created_at.strftime('%m-%d-%Y')
	    }
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
		golinks = GoLink.where('id in (?)', ids)
		golinks_by_id = golinks.index_by(&:id)
		puts golinks_by_id
		golinks = ids.map{|x| golinks_by_id[x]}
		puts golinks
		return golinks
	end



	def self.search_my_links(search_term, email)
		results = GoLink.search(query: {multi_match: {query: search_term, fields: ['key^3', 'tags^2', 'description', 'text', 'url', 'member_email'], fuzziness:1}}, :size=>100).results
		return self.search_results_to_golinks(results)
	end

	def get_permissions
		(self.permissions and self.permissions != '') ? self.permissions : 'Only Officers'
	end
	
	def can_view(member)
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
