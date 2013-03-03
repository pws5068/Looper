var Group = {};
Group.getGroupById = function(groupId) {
	for (var i = 0; i < Group.groups.length; i++) {
		var group = Group.groups[i];
		if (group.id == groupId) {
			return group;
		}
	}
	
	return null;
}

function GroupsController($scope, $window, $http) {
	// To do load in groups
	
	$http.get('/groups').success(function(data) {
		$scope.groups = data;
		Group.groups = data;
		console.log(data);
	});
	
	$scope.selectGroup = function(group) {
		if (group == null) {
			$window.location.href = "#/shares";			
		} else {
			$window.location.href = "#/shares/" + group.id;			
		}
	};
}

GroupsController.$inject = ['$scope', '$window', '$http'];