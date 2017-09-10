class Member < ActiveRecord::Base
  scope :active, -> {where("is_active = true")}
  serialize :commitments

  

  def self.email_hash
    Member.all.index_by(&:email)
  end

  def self.committees
    ['CS', 'CO', 'FI', 'HT', 'MK', 'DS', 'TC', 'IN', 'EX']
  end

  def self.david
    Member.where(email:'davidbliu@gmail.com').first
  end

  def self.admin_emails
    ['davidbliu@gmail.com']
  end

  def is_admin?
    self.name == 'David Liu' or self.name == 'Min Tseng' or self.name == 'Alex Park'
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

  #
  # Groups
  #

  def self.officers
    return Member.active.where('position = ? OR position = ?',
          'chair', 'exec')
  end

  def self.execs
    return Member.active.where(committee:'EX')
  end

  def self.cms
    return Member.active.where('position = ?', 'CM')
        .where.not(committee:'GM')
  end

  def self.chairs_and_cms
    Member.active.where.not(committee: 'GM').order('committee asc')
  end

end
