function ProfileMenuController($scope, $http) {
	$http.get("/users/current").success(function(data) {
		data.thumb_url = data.thumb_url.replace("?type=large","");
		$scope.currentUser = data;
	});
}