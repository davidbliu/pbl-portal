class GoLinkCopyGroup < ActiveRecord::Base
	belongs_to :go_link_copy
	belongs_to :group
end
