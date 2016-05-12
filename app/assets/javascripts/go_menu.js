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

function updateBatchModal(golinks){
	$('#batch-num').text(golinks.length);
	$('#batch-selected').text(_.map(golinks, function(x){
		return x.key;
	}).join(', '));
}

function showEditModal(){
	$.ajax({
		url: '/go/ajax_get_checked',
		type:'get',
		success:function(data){
			updateBatchModal(data);
			$('#go-edit-modal').modal('show');
		}
	})
}

$(document).ready(function(){
	$('#groups-input').keyup(function(){
		filterGroups($(this).val());
	});
});