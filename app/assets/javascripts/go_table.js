
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
	$('#golink-info-outer').show(150);
}
function hideGolinkInfo(data){
	$('#golink-info-outer').hide(150);
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

function getGroupsChecked(){
	var checked = [];
	$('.group-checkbox').each(function(){
		if($(this).is(':checked')){
			checked.push($(this).attr('data-key'));
		}
	});
	return checked;
}

function saveGoLink(id){
	$.ajax({
		url: '/go/update',
		type:'post',
		data:{
			id: id,
			url: $('#url-input').val(),
			description: $('#description-input').val(),
			key: $('#key-input').val(),
			groups: getSelectedGroupIds()
		},
		success:function(data){
			console.log('saved');
			$('#'+id+'-key').text(data.key);
			$('#'+id+'-key').attr('href', data.url);
			$('#'+id+'-description').text(data.description);
			$('#'+id+'-group_string').text(data.group_string);
			$('#'+id+'-tr').fadeOut(200).fadeIn(200);
			hideGolinkInfo();
		}
	})
}

function destroyGoLink(id){
	$.ajax({
		url: '/go/destroy/'+id,
		type:'post',
		success:function(data){
			$('#'+id+'-tr').remove();
			hideGolinkInfo();
		}
	})
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
$('.golink-row').click(function(event){
	hideGolinkInfo();
	if($(event.target).hasClass('golink-checkbox') || 
		$(event.target).hasClass('mute-info')){
		return;
	}
	$.ajax({
		url:'/go/show/'+$(this).attr('data-id'),
		type:'get',
		success: function(data){
			showGolinkInfo(data);
		}
	});
});


$('html').click(function(){
	hideGolinkInfo();
});
$('#golink-info-outer').click(function(event){
	event.stopPropagation();
})

});