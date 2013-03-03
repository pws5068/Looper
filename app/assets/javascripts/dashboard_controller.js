function DashboardController($scope, $routeParams, $http) {
	$scope.groupId = $routeParams.groupId;
	
	// TODO: Show loader if local data is empty
	$http.get('/shares').success(function(data) {
		var shares = data;
		for (var i = 0; i < data.length; i++) {
			var share = shares[i];
			var groupId = share.group_id;
			var group = Group.getGroupById(groupId);
			share.group = group;
		}
		
		$scope.shares = data;
	});
	
	$scope.selectShare = function(share) {
		// TODO: Expand the share
	}
}

DashboardController.$inject = ['$scope', '$routeParams', '$http'];