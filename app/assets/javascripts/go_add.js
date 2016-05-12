

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
	_.each(selectedGroupNames, function(name){
		div = $("<div class = 'label label-default group-name-tag'></div>");
		$(div).text(name);
		$(tag_selector).append(div);
	});
	$('.group-name-tag').click(function(){
		console.log('clicked');
		name = $(this).text();
		selectedGroupNames = _.filter(selectedGroupNames, function(x){
			return x != name;
		});
		console.log(selectedGroupNames);
		updateSelectedGroupsTag(tag_selector);
	})
}
// transfers name from input box to selected div 
function transfer(name){
	if(_.contains(group_names, name)){
		 selectedGroupNames.push(name);
		 selectedGroupNames = _.uniq(selectedGroupNames);
		 updateSelectedGroupsTag('#selected-groups');
	  	$('#groups-typeahead').val('');
	  	$('#groups-typeahead').typeahead('val', '');
	}
	else{
		DELAY = 150;
		$('#groups-typeahead').fadeOut(DELAY).fadeIn(DELAY).fadeOut(DELAY).fadeIn(DELAY);
	}
}

function getSelectedGroupIds(){
	return _.map(selectedGroupNames, function(x){
		return group_id_dict[x];
	})
}

var TYPEAHEAD_SELECTOR = '#groups-typeahead';
// var CLEAR_SELECTED_GROUPS = '#clear-selected-groups';
$(document).ready(function(){

	updateSelectedGroupsTag('#selected-groups');

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


	$('#save-golink-btn').click(function(){
		if($('#key-input').val() == ''){
			alert("Please enter a valid key");
			return;
		}
		$.ajax({
			url:'/go/update',
			type:'post',
			data:{
				id: golink_id,
				key: $('#key-input').val(),
				description: $('#description-input').val(),
				url: $('#url-input').val(),
				groups: getSelectedGroupIds()
			},
			success:function(data){
				window.location = '/go/menu'
			}
		})
	});

	$('#delete-golink-btn').click(function(){
		$.ajax({
			url:'/go/destroy/'+golink_id,
			type:'post', 
			success:function(data){
				window.location = '/go/menu'
			}
		})
	})
})