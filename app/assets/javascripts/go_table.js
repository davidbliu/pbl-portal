// Stuff in this file gets run on every ajax load

function renderCheckedIds(ids){
	$('.highlighted').each(function(){
		$(this).removeClass('highlighted');
	})
	$('.golink-row').each(function(){
		if(_.contains(ids, $(this).attr('data-id'))){
			$(this).addClass('highlighted');
		}
	})
	// update words and div on pages
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
			pullCheckedIds();

		}
	})
}

function pullCheckedIds(){
	$.ajax({
		url:'/go/get_checked_ids',
		type:'get',
		success:function(data){
			renderCheckedIds(data);
		}
	});
}
$(document).ready(function(){

	$('.mute-info').click(function(e){
		e.stopPropagation();
	})
	$('.edit-link').click(function(e){
		e.stopPropagation();
		$.ajax({
			url: '/go/show/'+$(this).attr('data-id'),
			type:'get',
			success:function(data){
				showGolinkInfo(data);
			}
		});
	})
	$('.golink-row').click(function(){
		if($(this).hasClass('highlighted')){
			url = '/go/remove_checked_id';
		}
		else{
			url = '/go/add_checked_id';
		}
		$.ajax({
			url: url,
			type: 'post',
			data: {id: $(this).attr('data-id')},
			success:function(data){
				renderCheckedIds(data);
			}
		})
	});

	$('.golink-row').hover(function(){
		$('.edit-link').each(function(){
			$(this).hide();
		})
		$(this).find('.edit-link').show();
	});

	// get checked ids and render them on page
	pullCheckedIds();

	$('#close-info-btn').click(function(){
		hideGolinkInfo();
	})

	$('html').click(function(){
		hideGolinkInfo();
	});

	$('#golink-info-outer').click(function(event){
		event.stopPropagation();
	})

});