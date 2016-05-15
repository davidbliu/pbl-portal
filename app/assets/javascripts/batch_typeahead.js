var substringMatcher = function(strs) {
  return function findMatches(q, cb) {
    var matches, substringRegex;
    matches = [];
    substrRegex = new RegExp(q, 'i');
    $.each(strs, function(i, str) {
      if (substrRegex.test(str)) {
        matches.push(str);
      }
    });

    cb(matches);
  };
};

function updateSelectedGroupsTag(tag_selector){
	$(tag_selector).html('');
	_.each(batchSelectedGroupNames, function(name){
		div = $("<div class = 'label label-default batch-group-name-tag'></div>");
		$(div).text(name);
		$(tag_selector).prepend(div);
	});
	$('.batch-group-name-tag').click(function(){
		name = $(this).text();
		batchSelectedGroupNames = _.filter(batchSelectedGroupNames, function(x){
			return x != name;
		});
		updateSelectedGroupsTag(tag_selector);
	})
	$('#batch-group-links').hide();
  	if(batchSelectedGroupNames.length > 0){
  		$('#batch-group-links').show();	
  	}
}

// transfers name from input box to selected div 
function transfer(name){
	if(_.contains(group_names, name)){
		 batchSelectedGroupNames.push(name);
		 batchSelectedGroupNames = _.uniq(batchSelectedGroupNames);
		 updateSelectedGroupsTag('#batch-selected-groups');
	  	$(TYPEAHEAD_SELECTOR).val('');
	  	$(TYPEAHEAD_SELECTOR).typeahead('val', '');

	}
	else{
		DELAY = 150;
		$(TYPEAHEAD_SELECTOR).fadeOut(DELAY).fadeIn(DELAY).fadeOut(DELAY).fadeIn(DELAY);
	}
}

function getSelectedGroupIds(){
	return _.map(batchSelectedGroupNames, function(x){
		return group_id_dict[x];
	})
}

function getSelectedBatchGroupIds(){
	return _.map(batchSelectedGroupNames, function(x){
		return group_id_dict[x];
	})
}

function batchAddGroups(){
	batchUpdateGroups({
		add: getSelectedBatchGroupIds(),
		remove: []
	});
}
function batchUpdateGroups(data){
	$.ajax({
		url: '/go/batch_update_groups',
		type:'post',
		data: data,
		success:function(data){
			window.location.reload();
		}
	})
}

function batchRemoveGroups(){
	batchUpdateGroups({
		remove: getSelectedBatchGroupIds(),
		add: []
	});
}
var TYPEAHEAD_SELECTOR = '#batch-group-typeahead';
var batchSelectedGroupNames = [];

$(document).ready(function(){
	setTimeout(function(){
		$(TYPEAHEAD_SELECTOR).typeahead({
		  hint: true,
		  highlight: true,
		  minLength: 1,
		},
		{
		  name: 'Groups',
		  source: substringMatcher(group_names),
		});

		$(TYPEAHEAD_SELECTOR).bind('typeahead:selected', function(obj, datum, name) {      
		  transfer(datum);
		});

		
		$(TYPEAHEAD_SELECTOR).keypress(function(e) {
		    if(e.which == 13) {
		        transfer($(this).val());
		    }
		});
	}, 1000);	
});
