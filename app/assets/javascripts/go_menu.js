function filterGroups(q){
	
	$('.group-div').each(function(){
		$(this).show();
	});

	if(q != ''){
		$('.group-div').each(function(){
			if($(this).attr('data-group').toLowerCase().indexOf(q) == -1){
				$(this).hide();
			}
		});
	}
	
}
$(document).ready(function(){
	$('#groups-input').keyup(function(){
		filterGroups($(this).val());
	});
});