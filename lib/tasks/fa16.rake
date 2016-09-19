require 'csv'
namespace :fa16 do
  task :members => :environment do 
    csv_text = File.read('fa16members.csv')
    csv = CSV.parse(csv_text, :headers => true)
    fa16 = 'Fall 2016'
    csv.each do |row|
      row = row.to_hash
      name = row['Name']
      committee = row['Committee']
      email = row['Email']
      position = row['Position']
      phone = row['Phone Number']
      major = row['Major']
      returning = row['Returning'] == 'FALSE' ? true : false
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
      m.name = name
      m.email = email
      m.latest_semester = fa16
      m.committee = committee
      m.position = position
      m.phone = phone
      m.major = major
      m.is_active = true
      # m.save!
    end
  end
end
