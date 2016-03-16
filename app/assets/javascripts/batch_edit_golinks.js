$(document).ready(function(){

$('#save-btn').click(function(){
	addGroups = [];
	removeGroups = [];
	$('.group-add-check').each(function(){
		if($(this).is(':checked')){
			addGroups.push($(this).attr('data-key'));
		}
	});
	$('.group-remove-check').each(function(){
		if($(this).is(':checked')){
			removeGroups.push($(this).attr('data-key'));
		}
	});
	$.ajax({
		url:'/go/batch_update',
		type:'post',
		data:{
			ids: golink_ids,
			add_groups: addGroups,
			remove_groups: removeGroups
		}, 
		success: function(data){
			window.location.reload();// = '/go';
		}
	});
});


});