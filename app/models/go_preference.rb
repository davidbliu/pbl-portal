class GoPreference < ActiveRecord::Base
  serialize :default_group_ids
  serialize :search_group_ids

  def self.get_pref(email)
    GoPreference.where(email: email).first_or_create
  end
  def self.default_group_ids(email)
    pref = self.get_pref(email)
    default_ids =  pref.default_group_ids
    default_ids ||= []
    return default_ids
  end
  
  def self.set_default_group_ids(email, ids)
    pref = self.get_pref(email)
    pref.default_group_ids = ids
    pref.save
  end

  def self.search_group_ids(email)
    pref = self.get_pref(email)
    search_ids = pref.search_group_ids
    search_ids ||= Group.groups_by_email(email).pluck(:id)
    return search_ids
  end

  def self.set_search_group_ids(email, ids)
    pref = self.get_pref(email)
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

  def self.set_landing_group_id(email, id)
    pref = self.get_pref(email)
    if id != nil and id != '' and Group.find(id)
      pref.landing_group_id = id.to_i
    else
      pref.landing_group_id = nil
    end
    pref.save
  end

  def self.landing_group_id(email)
    pref = self.get_pref(email)
    pref.landing_group_id
  end

  def self.landing_group(email)
    lid = self.landing_group_id(email)
    if lid
      return Group.find(lid)
    else
      return nil
    end
  end



end
