class Member < ActiveRecord::Base
  serialize :commitments
  
  def self.get_group(group)
    group = group.downcase
    if group == 'all'
      return Member.current_members
    elsif self.committees.include?(group.upcase)
      return Member.current_members
        .where(committee: group.upcase)
    elsif group == 'officers'
      return Member.current_members.where('position = ? OR position = ?',
          'chair', 'exec')
    elsif group == 'cms'
      return Member.current_members.where('position = ?', 'cm')
    end
  end

  def self.groups
    committees = self.committees
    gps = ['All', 'Officers', 'CMs']
    return gps+ committees
  end
  def self.email_hash
    Member.all.index_by(&:email)
  end

  def self.committees
    ['CS', 'CO', 'FI', 'HT', 'MK', 'GM', 'PD', 'PB', 'SO', 'WD', 'IN']
  end

  def self.david
    Member.where(email:'davidbliu@gmail.com').first
  end

  def is_admin?
    self.name == 'David Liu' or self.name == 'Haruko Ayabe'
  end

  def is_officer?
    self.position == 'chair' or self.position == 'exec'
  end

  def get_commitments
    self.commitments ? self.commitments : []
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

  def self.current_members(semester = Semester.current_semester)
    Member.where(latest_semester: semester)
  end

  def self.execs
    self.current_members.where(position: 'exec')
  end
  def self.officers
    self.current_members.where('position = ? OR position = ?',
      'exec','chair')
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

  def self.check_csv
    names = []
    CSV.foreach("contact_sheets/sp16.csv") do |row|
      member = Member.where(email: row[1]).first
      if member == nil
        names << row[0]
      end
    end
    puts names
  end
  def self.sp16_import
    Position.where(semester: 'Spring 2016').destroy_all
    CSV.foreach("contact_sheets/sp16.csv") do |row|
      member = Member.where(email: row[1]).first_or_create!
      member.name = row[0]
      member.latest_semester = "Spring 2016"
      member.committee = row[2]
      member.position = row[5].downcase
      if row[3] and row[3] != ''
        member.phone = row[3]
      end
      if row[4] and row[4] != ''
        member.major = row[4]
      end
      member.save

      # create a position for them
      pos = Position.where(member_email: row[1], 
        semester:'Spring 2016').first_or_create
      pos.committee = member.committee
      pos.position = member.position
      pos.save
    end


  end
end
