class GoPreference < ActiveRecord::Base
  serialize :default_group_ids
  serialize :search_group_ids

  def self.default_group_ids(email)
    pref = GoPreference.where(email: email).first_or_create
    default_ids =  pref.default_group_ids
    default_ids ||= []
    return default_ids
  end
  
  def self.set_default_group_ids(email, ids)
    pref = GoPreference.where(email: email).first_or_create
    pref.default_group_ids = ids
    pref.save
  end

  def self.search_group_ids(email)
    pref = GoPreference.where(email: email).first_or_create
    search_ids = pref.search_group_ids
    search_ids ||= Group.groups_by_email(email).pluck(:id)
    return search_ids
  end

  def self.set_search_group_ids(email, ids)
    pref = GoPreference.where(email: email).first_or_create
    pref.search_group_ids = ids
    pref.save
  end

  def self.default_groups(email)
    ids = self.default_group_ids(email)
    Group.where('id in (?)', ids)
  end

  def self.search_groups(email)
    ids = self.search_group_ids(email)
    Group.where('id in (?)', ids)
  end

end
