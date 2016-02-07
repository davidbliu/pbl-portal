class ParseGoLinkClick < ParseResource::Base
  fields :key, :golink_id, :member_email, :time, :createdAt, :updatedAt

  def self.migrate
  	skip = 0
  	lim = 10000
  	res = ParseGoLinkClick.limit(lim).skip(lim*skip).all
  	while res.length > 0
  		res.each do |click|
  			puts click.member_email.to_s + ' ' +click.key.to_s
  		end
  		skip += 1
  		res = ParseGoLinkClick.skip(100*skip).all
  	end
  end
end
