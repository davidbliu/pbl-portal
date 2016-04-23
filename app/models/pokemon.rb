class Pokemon


def self.pokegex
	Regexp.new(self.pokemap.keys.map{|x| x.to_s}.join('|'))
end
def self.pokemap
{
	bulbasaur: "http://vignette2.wikia.nocookie.net/pokemon/images/0/08/Who's_That_Pok%C3%A9mon_(IL010).png/revision/latest?cb=20120124200439",
	venasaur: "https://i.ytimg.com/vi/-EyeGROXZmo/maxresdefault.jpg",
	squirtle: 'https://i.ytimg.com/vi/GzxCAzp0hpU/hqdefault.jpg',
	blastoise: 'http://i974.photobucket.com/albums/ae229/dlh1231/blastoise.png',
	charizard: "https://i.ytimg.com/vi/yCeIDi3Y9eU/hqdefault.jpg",
	geodude: "http://i974.photobucket.com/albums/ae229/dlh1231/geodude.png",
	diglet: "https://i.ytimg.com/vi/U-GkTMvt4sA/hqdefault.jpg",
	sandshrew: "http://img02.deviantart.net/f29b/i/2011/239/b/4/who__s_that_pokemon_by_merlinemrys-d38qib8.png",
	ponyta: 'https://pbs.twimg.com/media/BlMB2ycIMAAjSVT.jpg',
	bellsprout: 'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQdxR72Rl9Fc3EH_R1xE2VhcLD4jJd-zI1pco3XOAR-4DOe9D7-EA',
	pikachu: 'http://i1142.photobucket.com/albums/n617/Mikes42/Guess-that-Pokemon-01-300x225.jpg',
	mewtwo: 'https://i.ytimg.com/vi/EE-xtCF3T94/hqdefault.jpg',
	bulbasaur: 'http://vignette2.wikia.nocookie.net/pokemon/images/0/08/Who%27s_That_Pok%C3%A9mon_%28IL010%29.png/revision/latest/scale-to-width-down/619?cb=20120124200439',
	raichu: "http://2.bp.blogspot.com/-naOOO44eot0/UBin71v-mwI/AAAAAAAAAEs/nVI2pnvaRZU/s1600/tumblr_lf55k7tmjA1qg4elmo1_500.png",
	clefairy: "https://pbs.twimg.com/media/Bj7LNh1IIAEmzxU.jpg",
	snorlax: "https://pbs.twimg.com/media/BmBmVcSCMAAX-Ux.jpg",
	scyther: "https://pbs.twimg.com/media/Bm9ZuE0CEAAETpM.jpg",
	ditto: "https://pbs.twimg.com/media/BlmQgqKCcAAal8L.jpg",
	cloyster: "https://pbs.twimg.com/media/BlTHRIYIQAAn3jr.jpg",
	hitmonchan: "https://pbs.twimg.com/media/Bk_IGjGIYAAtevR.jpg",
	vulpix: "https://pbs.twimg.com/media/Bk560yrIYAAAptv.jpg",
	gloom: "https://pbs.twimg.com/media/BkzaBSnIgAAEoSE.jpg",
	primeape: "https://pbs.twimg.com/media/Bkuej5HIUAAh55k.jpg",
	haunter: "https://pbs.twimg.com/media/BkqYb4bIYAIg6r1.jpg",
	gengar: "https://pbs.twimg.com/media/BkpACzMIQAElgZI.jpg",
	ghastly: "https://pbs.twimg.com/media/BkkKQFjIAAAuL-e.jpg",
	butterfree: "https://pbs.twimg.com/media/Bkd9P6WIUAIS5Nu.jpg",
	horsea: "https://pbs.twimg.com/media/BkZLdc_IIAAm5MJ.jpg",
	magikarp: "https://pbs.twimg.com/media/BkU8vYPIEAA42ZK.jpg",
	krabby: "https://pbs.twimg.com/media/BkUAXq2IQAAJdby.jpg",
	raticate: "https://pbs.twimg.com/media/BkPqVnoIQAAoGEC.jpg",
	marowak: "https://pbs.twimg.com/media/BkIh-EzIgAAa_c3.jpg",
	tentacool: "https://pbs.twimg.com/media/Bj_UJFxIIAIeKZ5.jpg",
	caterpie: "https://pbs.twimg.com/media/Bj52fvzIUAAVgBT.jpg",
	psyduck: "https://pbs.twimg.com/media/Bj0hya0IAAAFBG0.jpg",
	koffing: "https://pbs.twimg.com/media/Bj0AJBgIIAA4ail.jpg",
	poliwhirl: "https://pbs.twimg.com/media/BjxcHDiIMAAlN65.jpg",
	marill: "https://pbs.twimg.com/media/Bjwz4WVIcAAlkQx.jpg",
	treecko: "https://pbs.twimg.com/media/BjsuZu4IAAARXWq.jpg",
	seel: "https://pbs.twimg.com/media/BjnRhJSIMAALXjT.jpg",
	alakazam: "https://pbs.twimg.com/media/BjlWSMyIcAAYAYf.jpg",
	onyx: "https://pbs.twimg.com/media/BjlQkgvIYAA3ELq.jpg",
	magnemite: "https://pbs.twimg.com/media/BjlGXscIgAAMwpo.jpg",
	charmander: "https://pbs.twimg.com/media/BjlC8SgIIAEV_Xm.jpg"
}
end
end