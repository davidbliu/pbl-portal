namespace :events do
	desc "Rake task to make weekly update"
	task :update => :environment do
		TablingManager.gen_tabling
		Pablo.update_tabling_all

		Pablo.reset_aliases
		Pablo.reupdate_pairs
		Pablo.send_pairing_all
	end

	desc "Rake task to warn people of upcoming udpate"
	task :warn => :environment do
		Pablo.send_pablo_update_warning
	end
end
