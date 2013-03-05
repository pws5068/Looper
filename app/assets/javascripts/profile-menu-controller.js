function ProfileMenuController($scope, $http) {
	$http.get("/users/current").success(function(data) {
		$scope.currentUser = data;
	});
}

ProfileMenuController.$inject = ['$scope', '$http'];