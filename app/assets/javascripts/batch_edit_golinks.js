$(document).ready(function(){

$('.group-btn').click(function(){
	console.log($(this).attr('data-action'));
	groups = [];
	$('.group-check').each(function(){
		if($(this).is(':checked')){
			groups.push($(this).attr('data-key'));
		}
	});
	$.ajax({
		url:'/go/batch_update_groups',
		type:'post',
		data:{
			ids: golink_ids,
			groups: groups,
			atype: $(this).attr('data-action')
		}, 
		success: function(data){
			window.location.reload();
		}
	});
});
$('.tag-btn').click(function(){
	atype = $(this).attr('data-action');
	tags = [];
	$('.tag-checkbox').each(function(){
		if($(this).is(':checked')){
			tags.push($(this).attr('data-name'));
		}
	});
	$.ajax({
		url:'/go/batch_update_tags',
		type:'post',
		data:{
			ids: golink_ids,
			tags: tags,
			atype: $(this).attr('data-action')
		},
		success:function(data){
			window.location.reload();
		}
	})
})

$('#create-tag-btn').click(function(){
	$.ajax({
		url:'/go_tag/create',
		type: 'post',
		data:{
			name: $('#tag-input').val()
		},
		success:function(data){
			window.location.reload();
		},
		error:function(data){
			alert(data.responseText);
		}
	})
});

});