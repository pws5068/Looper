function DashboardController($scope, $routeParams, $http) {
	$scope.groupId = $routeParams.groupId;
	
	/*$http.get('/shares').success(function(data) {
		$scope.shares = data;
		alert(' share length ' + data.length);
		console.log(data);
	});*/
	
	var allShares = [
		{
			title:"Goats Yelling Like Humans - Super Cut Compilation",
			date:"10 minutes ago",			
			thumb:"http://wac.450f.edgecastcdn.net/80450F/999thepoint.com/files/2012/09/Goat_Scream.png",
			url:"http://www.youtube.com/watch?v=PpccpglnNf0",
			group_id:1
		},
		{
			title:"What Coke Contains",
			date:"13 minutes ago",
			thumb:"https://d233eq3e3p3cv0.cloudfront.net/max/640/0*401zD80taSUTbIvq.png",
			url:"https://medium.com/the-ingredients-2/221d449929ef",
			group_id:2		
		}
	];
	
	var shares = [];
	for (var i in allShares) {
		var share = allShares[i];	
		if (share.group_id == $scope.groupId || $scope.groupId == null) {
			shares.push(share);
		}
	}

	$scope.shares = shares;
	
	$scope.selectShare = function(share) {
		// TODO: Expand the share
	}
}