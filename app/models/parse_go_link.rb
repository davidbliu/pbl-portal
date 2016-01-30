class ParseGoLink < ParseResource::Base
  fields :key, :url, :description, :permissions, :member_email, :num_clicks, :createdAt, :updatedAt
end
