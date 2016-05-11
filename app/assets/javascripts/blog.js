
function activateToggles(){
	$('.post-toggle').unbind('click').click(function(){
		showPostModal($(this).attr('id'));
	})
}

function getNextPage(){
	last_scroll_time = new Date().getTime() / 1000;
	page += 1;
	$.ajax({
		url: '/blog/ajax_scroll/'+page+ajax_params,
		type:'get',
		success:function(data){
			$('#post-area').append(data);
			activateToggles();
		}
	})
}

function showPostModal(id){
	$.ajax({
		url: '/blog/show/'+id,
		type:'get',
		success:function(data){
			$('#show-modal-content').html(data);
			$('#show-modal').modal('show');
		}
	});
}

function loadComments(id){
	$.ajax({
		url: '/blog/comments/'+id,
		type:'get',
		success:function(data){
			$('#show-modal-body').html(data);
		}
	});
}

function deleteComment(id){
	$.ajax({
		url: '/blog/delete_comment/'+id,
		type:'post',
		success:function(data){
			$('#'+id+'-comment-div').remove();
		}
	})
}
function saveComment(id){
	$.ajax({
		url:'/blog/post_comment/'+id,
		type:'post',
		data:{
			comment: $('#comment-textarea').val()
		},
		success:function(data){
			loadComments(id);
		}
	})
}

$(document).ready(function(){

	activateToggles();

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



	 $('#search-input').on('keypress', function (event) {
		 if(event.which === 13){
			$(this).attr("disabled", "disabled");
			if(is_list){
				window.location = '/blog?view=list&q='+$(this).val();
			}
			else{
				window.location = '/blog?q='+$(this).val();
			}
		 }
	 });
});