class Click < ActiveRecord::Base
	def to_json
		{
			email: self.email,
			path: self.path,
			params: self.params
		}
	end
end
