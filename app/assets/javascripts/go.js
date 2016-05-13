// pagination and search logic for the go menu page
function getNextPage(){
	last_scroll_time = new Date().getTime() / 1000;
	page+=1;
	console.log('getting page /go/ajax_scroll/'+page+ajax_params);
	$.ajax({
		url: '/go/ajax_scroll/'+page+ajax_params,
		type:'get',
		success:function(data){
			$('#go-table-container').append(data);
		}
	})
}

$(document).ready(function(){
	$('#search-input').keypress(function(e) {
	    if(e.which == 13) {
	    	searchTerm = $(this).val();
	    	if(group_id == -1){
	    		window.location = '?q='+searchTerm;
	    	}
	    	else{
	    		window.location = '?group_id='+group_id+'&q='+searchTerm;
	    	}
	    	
	    }
	});

	$(window).scroll(function(){
		pos = $(window).scrollTop();
		height = $(document).height()-$(window).height()-10;
		if(pos > height){
			now = new Date().getTime() / 1000;
			if(now-last_scroll_time > 1){
				getNextPage();
			}
		}
	})
});


