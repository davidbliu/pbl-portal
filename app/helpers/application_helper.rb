module ApplicationHelper
	def group_string(groups)
		if groups.length == 0
			return "Anyone"
		else
			return groups.map{|x| x.name}.join(', ')
		end
	end
end
