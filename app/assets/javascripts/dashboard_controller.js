function DashboardController($scope, $routeParams, $http) {
	$scope.groupId = $routeParams.groupId;
	
	// TODO: Show loader if local data is empty
	$http.get('/shares').success(function(data) {
		$scope.shares = data;
	});
	
	$scope.selectShare = function(share) {
		// TODO: Expand the share
	}
}
