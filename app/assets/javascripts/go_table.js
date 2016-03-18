
var checkedIds = [];
function getCheckedIds(){
	var checked = [];
	$('.golink-checkbox').each(function(){
		if($(this).is(':checked')){
			checked.push($(this).attr('data-id'));
		}
	});
	return checked;
}
function renderCheckedIds(ids){
	$('.golink-checkbox').each(function(){
		if(_.contains(ids, $(this).attr('data-id'))){
			$(this).prop('checked', true);
		}
		else{
			$(this).prop('checked', false);
		}
	});
	if(ids.length > 0){
		$('#checked-div').show();
	}
	else{
		$('#checked-div').hide();
	}
	$('#checked-count').text(ids.length);
}


function showGolinkInfo(data){
	$("#golink-info-container").html(data);
	$('#golink-info-outer').show();
}
function hideGolinkInfo(data){
	$('#golink-info-outer').hide();
}
function activateGolinkCheckbox(){
	$('.golink-checkbox').click(function(){
		var route = '/go/remove_checked_id';
		if($(this).is(':checked')){
			route = '/go/add_checked_id';
		}
		$.ajax({
			url: route, 
			type:'post',
			data:{
				id: $(this).attr('data-id')
			},
			success:function(data){
				renderCheckedIds(data);
			}
		});
	});	
}
$(document).ready(function(){

$.ajax({
	url:'/go/get_checked_ids',
	type:'get',
	success:function(data){
		renderCheckedIds(data);
	}
});
activateGolinkCheckbox();
$('#close-info-btn').click(function(){
	hideGolinkInfo();
})
$('.golink-row').click(function(){
		$.ajax({
			url:'/go/show/'+$(this).attr('data-id'),
			type:'get',
			success: function(data){
				showGolinkInfo(data);
			}
		});
});
});