class Member < ActiveRecord::Base
  serialize :commitments
  
  def self.david
    Member.where(email:'davidbliu@gmail.com').first
  end

  def is_officer?
    self.position == 'chair' or self.position == 'exec'
  end

  def self.hex_to_string(token)
    if not token
      return nil
    end
    s = token.scan(/../).map { |x| x.hex.chr }.join
    return s
  end

  def self.string_to_hex(email)
    hex_str = ''
    email.each_byte do |c|
      hex_str+=c.to_s(16)
    end
    return hex_str
  end

  def semester_position(semester)
    if semester == nil
      return self.position
    end
    pos = Position.where(member_email: self.email, semester: semester).first
    return pos
  end

  def self.current_members
    Member.where(latest_semester: 'Fall 2015')
  end

  def self.default_commitments
    default_com = Array.new(168)
    168.times{|i| default_com[i] = 0}
    return default_com
  end

  def to_json
    return {
      email: self.email,
      name: self.name,
      position: self.position,
      role:  self.role,
      phone: self.phone,
      latest_semester: self.latest_semester,
      commitments: self.commitments
    }
  end

  def self.sp16_import
    Position.where(semester: 'Spring 2016').destroy_all
    CSV.foreach("contact_sheets/sp16.csv") do |row|
      member = Member.where(email: row[1]).first_or_create!
      member.name = row[0]
      member.latest_semester = "Spring 2016"
      member.committee = row[2]
      member.position = row[5].downcase
      member.save

      # create a position for them
      pos = Position.where(member_email: row[1], 
        semester:'Spring 2016').first_or_create
      pos.committee = member.committee
      pos.position = member.position
      pos.save
    end

    Position.create(
      member_email:'davidbliu@gmail.com',
      committee:'GM',
      position:'chair',
      semester:'Spring 2016')

    david = Member.david
    david.latest_semester = 'Spring 2016'
    david.committee = 'GM'
    david.position = 'chair'
    david.save

  end
end
