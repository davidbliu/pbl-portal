class DefaultMessage

	def self.pokemon_message
		msg = {
			attachment: {
				type: 'image',
				payload: {
					url: 'https://i.ytimg.com/vi/GzxCAzp0hpU/hqdefault.jpg'
				}
			}
		}
	end

	def self.puppy_msg
		msg = {
			attachment: {
				type: 'image',
				payload: {
					url: 'http://41.media.tumblr.com/cf8cd327f9a0b329351b55b998140cb2/tumblr_nz10tuNhfp1rbibvmo1_500.jpg'
				}
			}
		}
	end
	def self.support_btn(name)
		{
			type:'postback',
			payload:"support #{name}",
			title: 'Send Support'
		}
	end
	def self.profile_btn(url)
		{
			type:'web_url',
			url: url,
			title: 'Profile'
		}
	end
	def self.platform_btn(name)
		{
		type:'postback',
		payload: "platform_for #{name}",
		title:'Platform'
		}
	end
	def self.candidate_card(name, positions, img, profile, platform)
		{
			title: name,
			subtitle: "Running for #{positions}",
			image_url: img,
			buttons:[
				self.profile_btn(profile),
				self.platform_btn(name),
				self.support_btn(name)
			]
		}
	end
	def self.platform_for(id, name)
		case name
		when 'Haruko Ayabe'
			url = 'http://i.imgur.com/RnvOr94.png'
		when 'Lulu Tao'
			url = 'http://i.imgur.com/8amafWr.png'
		when 'Alex Park'
			url = 'http://i.imgur.com/lVXvV6i.png'
		when "Cindy Kim"
			url = 'http://i.imgur.com/5KARe2S.png'
		when "Kenny Yoo"
			url = 'http://i.imgur.com/kRPMlE3.png'
		when 'Arnold Chan'
			url = 'http://i.imgur.com/UeSSkYr.png'
		when "Chris Huang"
			url = 'http://i.imgur.com/Dnvn11b.png'
		when "Michelle Ko"
			url = 'http://i.imgur.com/TPUL9Jz.png'
		else
			url = 'http://i.imgur.com/8amafWr.png'
		end
		msg = {
			attachment: {
				type: 'image',
				payload: {
					url: url
				}
			}
		}
		Pablo.send(id, msg)
	end
	def self.platforms
		ps = { 
			attachment: {
				type: 'template',
				payload: {
					template_type: "generic",
					elements: [
						self.candidate_card("Haruko Ayabe", 'President', 'http://i.imgur.com/38TSN8e.jpg', 'http://wd.berkeley-pbl.com/wiki/index.php/Haruko_Ayabe', 'http://i.imgur.com/RnvOr94.png'),
						self.candidate_card("Lulu Tao", "VP of Membership", 'http://i.imgur.com/3v8foVu.jpg', 'http://wd.berkeley-pbl.com/wiki/index.php/Lulu_Tao', 'http://i.imgur.com/8amafWr.png'),
						self.candidate_card('Alex Park', 'VP of Corporate Relations, VP of Campus Affairs', 'http://i.imgur.com/cwvX8MN.jpg', 'http://wd.berkeley-pbl.com/wiki/index.php/Alex_park', 'http://i.imgur.com/lVXvV6i.png'),
						self.candidate_card('Cindy Kim', 'VP of Corporate Relations', 'https://scontent-sjc2-1.xx.fbcdn.net/v/t1.0-9/12729253_10209020395368689_3341710015320779649_n.jpg?oh=9aff6b7e01110669c832839d11ab8033&oe=57A3D21B', 'http://wd.berkeley-pbl.com/wiki/index.php/Cindy_Kim', 'http://i.imgur.com/5KARe2S.png'),
						self.candidate_card('Kenny Yoo', 'VP of Corporate Relations', 'http://i.imgur.com/1gODg9w.jpg', 'http://wd.berkeley-pbl.com/wiki/index.php/Kenny_Yoo', 'http://i.imgur.com/kRPMlE3.png'),
						self.candidate_card('Arnold Chan', 'VP of Campus Affairs', 'http://i.imgur.com/62Gbcdw.jpg', 'http://wd.berkeley-pbl.com/wiki/index.php/Arnold_Chan', 'http://i.imgur.com/UeSSkYr.png'),
						self.candidate_card('Chris Huang', 'VP of Campus Affairs', 'https://scontent-sjc2-1.xx.fbcdn.net/v/t1.0-9/12687825_1032372526829744_8928423147268770439_n.jpg?oh=f0ead777e0d9932720d1dc4e549482d0&oe=577715CA', 'http://wd.berkeley-pbl.com/wiki/index.php/Chris_Huang', 'http://i.imgur.com/Dnvn11b.png'),
						self.candidate_card("Michelle Ko", 'VP of Finance', 'http://i.imgur.com/U9XUqcn.jpg', 'http://wd.berkeley-pbl.com/wiki/index.php/Michelle_Ko', 'http://i.imgur.com/TPUL9Jz.png')
					]
				}
			}
		}
		puts ps
		return ps
	end

	def self.fourth_gen
	end
end