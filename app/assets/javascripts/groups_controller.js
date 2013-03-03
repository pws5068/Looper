function GroupsController($scope, $window) {
	// To do load in groups
	$scope.groups = [
		{title:"Paul, Matt, Rick, and Zain", prettyDate:"yesterday", groupId:"100"},
		{title:"Family", prettyDate:"1 week ago", groupId:"200"}
	];
	
	$scope.selectGroup = function(group) {
		if (group == null) {
			$window.location.href = "#/shares";			
		} else {
			$window.location.href = "#/shares/" + group.groupId;			
		}

	};
}