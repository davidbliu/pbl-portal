namespace :events do
	desc "Rake task to update tabling"
	task :update_tabling => :environment do
#		TablingManager.gen_tabling
#		Pablo.update_tabling_all

        end
        desc "Rake task to update Pablo"
        task :update_pablo => :environment do
#		Pablo.reset_aliases
#		Pablo.reupdate_pairs
#		Pablo.send_pairing_all
	end

	desc "Rake task to warn people of upcoming udpate"
	task :warn => :environment do
#		Pablo.send_pablo_update_warning
	end
end
