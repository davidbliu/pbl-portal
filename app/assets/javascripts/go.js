function getCheckedGroups(type){
	var ids = [];
	$('.batch-group-checkbox').each(function(){
		if($(this).is(':checked') && $(this).attr('data-type') == type){
			ids.push($(this).attr('data-id'));
		}
	});
	return ids;
}
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
	$('#update-groups-btn').click(function(){
		$.ajax({
			url: '/go/batch_update_groups',
			type:'post',
			data:{
				add: getCheckedGroups('add'),
				remove: getCheckedGroups('remove')
			},
			success:function(data){
				window.location.reload();
			}
		})
	});
	$('#search-input').keypress(function(e) {
	    if(e.which == 13) {
	    	searchTerm = $(this).val();
	    	window.location = '?q='+searchTerm;
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


