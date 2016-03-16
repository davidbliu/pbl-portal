var editData;
var permissionsEditId;
function activateEditable(){
	$('.editable').attr('contenteditable', true);
	$('.editable').unbind('focusin').focusin(function(){
		editData = $(this).text();
	});
	$('.editable').unbind('focusout').focusout(function(){
		if ($(this).text() != editData){
			var row = $(this).parent();
			var updateData = {};
			updateData['id'] = $(this).parent().attr('data-id');
			updateData[$(this).attr('data-field')] = $(this).text().trim();
			$.ajax({
				url: '/go/update',
				type: 'post',
				data: updateData,
				success: function(data){
					$(row).fadeOut(100).fadeIn(100);
				}
			})
		}
	});
}

function getCheckedPermissions(){
	var permissionsList = [];
	$('.permissions-check').each(function(){
		if($(this).is(':checked')){
			permissionsList.push($(this).attr('data-key'));
		}
	});
	return permissionsList.join(',');
}
function closeBlackFilm(){
	$('#black-film').click(function(){
		$('.go-modal').each(function(){
			$(this).hide();
		});
	});
}
function activateEditPermissions(){
	$('.permissions-td').click(function(){
		var currentPermissions = $(this).attr('data-permissions').split(',');
		permissionsEditId = $(this).parent().attr('data-id');
		// mark permissions
		$('.permissions-check').each(function(){
			$(this).prop('checked', false);
		});
		_.each(currentPermissions, function(x){
			$('#'+x.replace(' ', '')+'-checkbox').prop('checked', true);
		});
		$('#permissions-key').text($(this).attr('data-key'));
		$('#permissions-edit').show();
		$('#black-film').show();
	});
	$('#permissions-cancel').click(function(){
		$('#permissions-edit').hide();
		$('#black-film').hide();
		permissionsEditId = null;
	});
	$('#permissions-clear').click(function(){
		$('.permissions-check').each(function(){
			$(this).prop('checked', false);
		});
	});
	$('#permissions-save').click(function(){
		var row = $('#' + permissionsEditId + '-row');
		updatedPermissions = getCheckedPermissions();
		if(updatedPermissions == ''){
			updatedPermissions = 'Anyone';
		}
		updateData = {
			'id': permissionsEditId,
			'groups': updatedPermissions
		}
		$.ajax({
			url: '/go/update',
			type: 'post',
			data: updateData,
			success: function(data){
				$('#'+ permissionsEditId + '-permissions-td').text(updatedPermissions);
				$('#'+ permissionsEditId + '-permissions-td').attr('data-permissions', updatedPermissions.replace(' ', ''));
				$(row).fadeOut(100).fadeIn(100);
				permissionsEditId = null;
				$('#permissions-edit').hide();
				$('#black-film').hide();
			}
		})
	});
}
function activateDelete(){
	$('.delete-link').click(function(){
		id = $(this).attr('data-id');
		$.ajax({
			url: '/go/destroy',
			type:'post', 
			data:{id: id},
			success:function(data){
				$('#'+id+'-row').remove();
			}
		});
	});
}
function getCheckedKeysAndIds(){
	var checkedKeys = [];
	var checkedIds = [];
	$('.golink-checkbox').each(function(){
		if($(this).is(':checked')){
			checkedKeys.push($(this).attr('data-key'));
			checkedIds.push($(this).attr('data-id'));
		}
	});
	return [checkedKeys, checkedIds];
}
function highlightCheckedParents(){
	$('.hilite').each(function(){
		$(this).removeClass('hilite');
	})
	$('.golink-checkbox').each(function(){
		if($(this).is(':checked')){
			$(this).parents('.golink-row').addClass('hilite');
		}
	})
}
function activateCheckboxes(){
	$('.golink-checkbox').click(function(){
		checkedData = getCheckedKeysAndIds();
		checkedIds = checkedData[1];
		checkedKeys = checkedData[0];
		if(checkedIds.length > 0){
			$('#batch-number').text(checkedKeys.length);
			$('#batch-edit-div').show();
		}
		else{
			$('#batch-edit-div').hide();
		}
		highlightCheckedParents();
	});
	$('#batch-delete-btn').click(function(){
		var checkedIds = getCheckedKeysAndIds()[1];
		window.location.href = '/go/batch_delete?ids='+JSON.stringify(checkedIds);
	});
	$('#batch-edit-btn').click(function(){
		var checkedIds = getCheckedKeysAndIds()[1];
		window.location.href = '/go/batch_edit?ids='+JSON.stringify(checkedIds);
	});
	$('#batch-cancel-btn').click(function(){
		$('.hilite').each(function(){
			$(this).removeClass('hilite');
		})
		$('.golink-checkbox').each(function(){
			$(this).prop('checked', false);
		});
		$('#batch-edit-div').hide();
	})
}
activateCheckboxes();
closeBlackFilm();
activateDelete();
activateEditable();
activateEditPermissions();