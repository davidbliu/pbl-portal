class MigrateGroups
	def self.go
		GoLink.all.each do |gl|
			groups = ''
			suffix = 'fa15'
			if gl.semester == 'Spring 2016'
				suffix = 'sp16'
			end
			if gl.permissions == 'Only PBL'
				groups = "pbl-#{suffix}"
			elsif gl.permissions == 'Only Officers'
				groups = "of-#{suffix}"
			elsif gl.permissions == 'Only Execs'
				groups = "ex-#{suffix}"
			else
				groups = gl.permissions ? gl.permissions : 'Anyone'
			end
			gl.groups = groups
			gl.save
		end
	end
end