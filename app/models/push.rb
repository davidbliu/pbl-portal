class Push < ActiveRecord::Base
	serialize :response
	serialize :member_emails
end
