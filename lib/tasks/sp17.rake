require 'csv'
namespace :sp17 do
  task :update_officers => :environment do
      csv_text = File.read('sp17_officers.csv')
      csv = CSV.parse(csv_text, :headers => true)
      csv.each do |row|
        row = row.to_hash
        name = row['Name']
        email = row['Preferred Email']
        committee = row['Committee']
        position = row['Position']
        major = row['1st Major']
        row_string = "#{name}, #{committee}, #{position}, #{major}"
        Member.where(:email => email).each do |m|
          puts "Found member with email #{email}"
          m.committee = committee
          m.position = position
          m.major = major
          m.save!
        end
      end
  end

  task :update_cms => :environment do
    csv_text = File.read('sp17_cms.csv')
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      row = row.to_hash
      first = row['First']
      last = row['Last']
      email = row['Email']
      committee = row['Committee']
      name = "#{first} #{last}"
      row_string = "#{name}, #{email}, #{committee}"
      member = Member.find_by_email(email)
      if member == nil
        puts "NEW MEMBER: #{row_string}"
        member = Member.new
      else
        puts "RETURNING: #{row_string}"
      end
      member.name = name
      member.email = email
      member.committee = committee
      member.position = 'CM'
      member.is_active = true
      member.latest_semester = 'Spring 2017'
      member.save!
    end
  end
end
