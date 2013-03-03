function GroupsController($scope, $window, $http) {
	// To do load in groups
	
	$http.get('/groups').success(function(data) {
		$scope.groups = data;
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