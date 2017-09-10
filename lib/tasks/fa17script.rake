require 'csv'
namespace :fa17 do
  task :members => :environment do
    csv_text = File.read('fa17members.csv')
    csv = CSV.parse(csv_text, :headers => true)
    fa17 = 'Fall 2017'
    csv.each do |row|
      row = row.to_hash
      name = row['Name']
      committee = row['Committee']
      email = row['Email']
      position = row['Position']
      phone = row['Phone Number']
      major = row['Major']
      returning = row['Returning'] == 'FALSE' ? false : true 
      row_string = "#{name},#{email},#{committee},#{position},#{phone},#{major},#{returning}"
      qm = Member.where(email: email)
      if qm.length > 0
        puts "RETURNING: #{row_string}"
        m = qm.first
      elsif returning
        puts "MISSING: #{row_string}"
        #m = Member.where(name: name).first
        m = Member.new
      else
        puts "CREATING: #{row_string}"
        m = Member.new
      end
      m.name = name
      m.email = email
      m.latest_semester = fa17
      m.committee = committee
      m.position = position
      m.phone = phone
      m.major = major
      m.is_active = true
      m.save!
    end
  end
end
