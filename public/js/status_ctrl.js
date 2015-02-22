angular.module('BookSelector', [])
    .controller('StatusCtrl', ['$scope', function ($scope) {
        $scope.ofbi_status_selector = 2;
        $scope.selected = function($state) {
            return ($scope.ofbi_status_selector >= $state ? "ofbi-status-selected" : "");
        };
    }])
    .controller('BookListCtrl', ['$scope', '$http', function ($scope, $http) {
        /*$http.get('api/index.json').success(function(data) {
            $scope.books = data;
        });*/
        $scope.books = [
            {'name': 'Genesis',
             'lsCount': 1,
             'lfCount': 2,
             'sfCount': 3,
             'chapterCount': 50
            },
            {'name': 'Exodus',
             'lsCount': 4,
             'lfCount': 5,
             'sfCount': 6,
             'chapterCount': 52
            }
        ];
        $scope.selected = function($state) {
            return ($scope.ofbi_status_selector >= $state ? "ofbi-status-selected" : "");
        };
    }]);
