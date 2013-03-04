(function(window, document, undefined)  {

    var Looper = function () {
        this.names = [];
        this.groups = [];
        this.groupUserNames = [];
    };

    Looper.prototype = {
        initIfNeeded: function() {
            var container = $('#LOOPER_CONTAINER');

            if (container.length > 0) {
                this.hideMainContainer();
            } else {
                this.init();
            }
        },

        init: function() {
            var container = document.createElement('div');
            container.setAttribute('id', 'LOOPER_CONTAINER');

            document.getElementsByTagName('body')[0].appendChild(container);

            /*
             * Create the stylesheet
             */

            var css = document.createElement("link");
            css.setAttribute("rel", "stylesheet");
            css.setAttribute("type", "text/css");
            css.setAttribute("href", chrome.extension.getURL('looper.css'));

            container.appendChild(css);

            /*
             * Read in the main html
             */

            var self = this;

            var xhr = new XMLHttpRequest();
            xhr.open("GET", chrome.extension.getURL('looper.html'), true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    /*
                     * Put the main contents of the html file into the container
                     */

                    container.innerHTML += xhr.response;

                    /*
                     * Load the logo and animate the main section down
                     */

                    $('#LOOPER_LOGO').attr('src', chrome.extension.getURL('images/looper_logo.png'));

                    $('#LOOPER_MAIN').css('top', '-1' + $('#LOOPER_MAIN').css('height'))
                    .animate({
                        top: '0px'
                    }, {
                        duration: 500
                    });

                    /*
                     * Add the click listener to close the main section when needed
                     */

                    $('body').click(function(event) {
                        if (event.clientY > 55) {
                            self.hideMainContainer();
                        }
                    });

                    $('#LOOPER_NAMES').keypress(function(event) {
                        if (event.keyCode == 13) {
                            self.transitionToTags();
                        } else if (event.keyCode == 32) {
                            self.checkForCompletedName();
                        }
                    });

                    self.loadGroupsData();
                }
            };
            xhr.send();
        },

        loadGroupsData: function() {
            var self = this;

            $.ajax({
                url: 'http://fathomless-lake-4709.herokuapp.com/users/friends.json',//http://fathomless-lake-4709.herokuapp.com/groups.json',
                type: 'GET'
            }).done(function(data) {
                var groups = [];
                var groupUserNames = [];

                /*data.forEach(function(group, index) {
                    var object = {
                        id: group.id,
                        users: ''
                    };

                    group.users.forEach(function(person, index) {
                        object.users += person.name + ', ';
                    });

                    object.users = object.users.substring(0, object.users.length - 2);

                    groups.push(object);
                    groupUserNames.push(object.users);
                });*/

                data.friends.forEach(function(friend, index) {
                    if (friend.name) {
                        groups.push({
                            id: friend.id,
                            name: friend.name
                        });
                        groupUserNames.push(friend.name);
                    }
                });

                data.network_friends.forEach(function(friend, index) {
                    if (friend.name) {
                        groups.push({
                            id: friend.id,
                            name: friend.name
                        });
                        groupUserNames.push(friend.name);
                    }
                });

                self.groups = groups;
                self.groupUserNames = groupUserNames;

                $('#LOOPER_NAMES').autocomplete({
                    source: function(request, response) {
                        var term = self._removeCurrentNamesFromString(request.term);

                        if (term.length > 2) response($.ui.autocomplete.filter(self.groupUserNames, term));
                    }
                });
            });
        },

        checkForCompletedName: function() {
            var term = this._removeCurrentNamesFromString($('#LOOPER_NAMES').val());
                self = this;

            this.groups.forEach(function(user, index) {
                if (term == user.name.toLowerCase()) {
                    self.names.push(user.name);
                    $('#LOOPER_NAMES').autocomplete("close");
                }
            });
        },

        _removeCurrentNamesFromString: function(string) {
            var term = $.trim(string.toLowerCase());

            this.names.forEach(function(name, index) {
                term = $.trim(term.replace(name.toLowerCase(), ''));
            });

            return term;
        },

        transitionToTags: function() {
            $('#LOOPER_NAMES').autocomplete("close").autocomplete("disable")
            .animate({
                paddingLeft: '100px',
                opacity:0
            }, {
                duration: 300,
                easing: 'swing'
            });

            $('#LOOPER_TAGS').css('display', 'block').animate({
                opacity: 1
            }, {
                duration: 300,
                complete: function() {
                    $('#LOOPER_TAGS').focus();
                }
            });
        },

        /*
         * Animates the main section off the screen and then removes everything from the DOM
         */

        hideMainContainer: function() {
            $('#LOOPER_MAIN').animate({
                top: '-1' + $('#LOOPER_MAIN').css('height')
            }, {
                duration: 400,
                complete: function() {
                    $('#LOOPER_CONTAINER').remove();
                }
            });
        }
    };

    /*
     * Kick things off
     */

    var looper = new Looper();
    looper.initIfNeeded();

})(window, document);
