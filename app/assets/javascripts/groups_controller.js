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
	$scope.$watch('groups', function(value1, value2){
		setTimeout(function(){
			$("a.pretty-date").prettyDate();		
		}, 0);
	});
	
	$http.get('/groups').success(function(data) {
		$scope.groups = data;
		Group.groups = data;
	});
	
	$scope.isSelectedGroup = function(group) {
		return group == $scope.selectedGroup;
	}
	
	$scope.selectGroup = function(group, $event) {

		var unselecting = group == $scope.selectedGroup;
		
		$scope.selectedGroup = group;
		
		if (group == null || unselecting) {
			$window.location.href = "#/shares";			
		} else {
			$window.location.href = "#/shares/" + group.id;			
		}
	};
}

GroupsController.$inject = ['$scope', '$window', '$http'];