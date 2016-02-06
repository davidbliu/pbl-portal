require 'set'
class ParseMember < ParseResource::Base
  fields :name, :commitments, :email, :phone, :major, :role, :year, :committee, :position, :latest_semester, :createdAt
end
