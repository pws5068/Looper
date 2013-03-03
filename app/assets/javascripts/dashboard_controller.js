function DashboardController($scope, $routeParams) {
	$scope.groupId = $routeParams.groupId;
	var allShares = [
		{
			title:"Goats Yelling Like Humans - Super Cut Compilation",
			date:"10 minutes ago",			
			thumb:"http://wac.450f.edgecastcdn.net/80450F/999thepoint.com/files/2012/09/Goat_Scream.png",
			url:"http://www.youtube.com/watch?v=PpccpglnNf0",
			shareWith:100
		},
		{
			title:"What Coke Contains",
			date:"13 minutes ago",
			thumb:"https://d233eq3e3p3cv0.cloudfront.net/max/640/0*401zD80taSUTbIvq.png",
			url:"https://medium.com/the-ingredients-2/221d449929ef",
			shareWith:200			
		}
	];
	
	var shares = [];
	for (var i in allShares) {
		var share = allShares[i];	
		if (share.shareWith == $scope.groupId || $scope.groupId == null) {
			shares.push(share);
		}
	}

	$scope.shares = shares;
}