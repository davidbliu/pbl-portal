require 'csv'
namespace :sp17_officers do
	task :officers => :environment do
            csv_text = File.read('sp17_officers.csv')
	    csv = CSV.parse(csv_text, :headers => true)
	    sp_17 = 'Spring 2017'
	    csv.each do |row|
	      row = row.to_hash
	      name = row['Name']
	      committee = row['Committee']
	      email = row['Prefered Email']
	      position = row['Position']
	      phone = row['Phone Number']
	      major = row['1st Major']
	      returning = true
	      row_string = "#{name},#{committee},#{position},#{phone},#{major}"
	      qm = Member.where(email: email)
	      if qm.length > 0
	        puts "RETURNING: #{row_string}"
	        m = qm.first
	      elsif returning
	        puts "MISSING: #{row_string}"
	        m = Member.where(name: name).first
	      else
	        puts "CREATING: #{row_string}"
	        m = Member.new
	      end
              Member.update(m.id, name: name, committee: committee, position: position, phone: phone, major: major)
	  end
	end

        task :check => :environment do
          active_members = Member.where(:is_active => true)
          active_members.each do |member|
            puts "#{member.name}, #{member.committee}"
          end
        end
        
end
