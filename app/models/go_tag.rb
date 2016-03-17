class GoTag < ActiveRecord::Base
	def to_json
		{
			name: self.name,
			creator: self.creator,
			description: self.description
		}
	end

	def golinks(email)
		ids = GoLinkTag.where(tag_name: self.name).pluck(:golink_id)
		viewable = GoLink.can_view(email)
		ids = ids.select{|x| viewable.include?(x)}
		GoLink.where('id in (?)', ids)
	end
end
