function restoreGoLink(id){
	$.ajax({
		url:'/go/restore/'+id,
		type:'post',
		success:function(data){
			$('#'+id+'-row').remove();
		}
	})
}

function deleteGoLink(id){
	$.ajax({
		url:'/go/destroy_copy/'+id,
		type:'post',
		success:function(data){
			$('#'+id+'-row').remove();
		}
	})
}