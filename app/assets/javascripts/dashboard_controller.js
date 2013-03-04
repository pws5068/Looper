function DashboardController($scope, $routeParams, $http) {
	
	$scope.groupId = $routeParams.groupId;
	
	$scope.$watch('shares', function(value1, value2){
		setTimeout(function(){
			$("a.pretty-date").prettyDate();		
		}, 0);
	});
	
	if ($scope.groupId != null) {
		$http.get('/groups/' + $scope.groupId + '/shares').success(function(data) {
			$scope.handleShares(data);
		});		
	} else {
		// TODO: Show loader if local data is empty
		$http.get('/shares').success(function(data) {
			$scope.handleShares(data);
		});		
	}
	
	/**
		Convenience methods for processing shares after HTTP callback
	*/
	$scope.handleShares = function(shares) {		
		$scope.allShares = shares;
		$scope.filterAllShares();
	};
	
	/*
		When the user selects a share
	*/
	$scope.selectShare = function(share) {
		
	};
	
	$scope.hasUserSeen = function(user) {
		return user.viewed;
	}
	
	$scope.imageClassForMediaType = function(mediaType) {

		var mediaCssType = "media-icon";

		if (mediaType == "video") {
			mediaCssType = "media-icon video-icon";
		} else if (mediaType == "audio") {
			mediaCssType = "media-icon audio-icon";
		} else if (mediaType == "article") {
			mediaCssType = "media-icon article-icon";
		} else if (mediaType == "photo") {
			mediaCssType = "media-icon photo-icon";
		}
		
		return mediaCssType;
	};
	
	/*
		Sets the media type we are filtering
	*/
	$scope.setMediaType = function(mediaType) {
		$scope.mediaType = mediaType;
		$scope.filterAllShares();
	};
	
	/*
		Sets the search query for controller
	*/
	$scope.setSearchQuery = function(query) {
		$scope.searchQuery = query;
		$scope.filterAllShares();
	};
	/*
		All visible shares will be filtered right here
	*/
	$scope.filterAllShares = function() {
		var filteredShares = [];
		for (var i = 0; i < $scope.allShares.length; i++) {
			var share = $scope.allShares[i];
			if ($scope.mediaType) {
				if (share.media_type == $scope.mediaType) {
					filteredShares.push(share);				
				}
			} else {
				filteredShares.push(share);
			}
		}
		
		if ($scope.searchQuery != null) {
			filteredShares = filteredShares.filter(function(share) {
				return share.title.toLowerCase().indexOf($scope.searchQuery.toLowerCase()) !== -1 ||share.description.toLowerCase().indexOf($scope.searchQuery.toLowerCase()) !== -1;
			});
		}
		
		$scope.shares = filteredShares;
	}
}

DashboardController.$inject = ['$scope', '$routeParams', '$http'];