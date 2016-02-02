class Member < ActiveRecord::Base
  serialize :commitments
  
  def self.david
    Member.where(email:'davidbliu@gmail.com').first
  end

  def is_officer?
    self.position == 'chair' or self.position == 'exec'
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
end
