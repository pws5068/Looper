(function(window, document, undefined)  {

    var Looper = function () {
        this.names = [];
        this.tags = [];
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
                        if (event.clientY > (55 + $('.ui-autocomplete').height())) {
                            self.hideMainContainer();
                        }
                    });

                    $('#LOOPER_NAMES').keypress(function(event) {
                        if (event.keyCode == 13) {
                            self.transitionToTags();
                        } else if (event.keyCode == 32) {
                            self.checkForCompletedName(event);
                        }
                    });

                    $('#LOOPER_NAMES').keyup(function(event) {
                        if (event.keyCode == 8) {
                            self.checkForDeletedName();
                        }
                    });

                    $('#LOOPER_TAGS').keypress(function(event) {
                        if (event.keyCode == 13) {
                            self.submitLoop();
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
                url: 'http://looper.io/users/friends.json',//http://fathomless-lake-4709.herokuapp.com/groups.json',
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
                            graphId: friend.id,
                            name: friend.name
                        });
                        groupUserNames.push(friend.name);
                    }
                });

                self.groups = groups;
                self.groupUserNames = groupUserNames;

                /*
                 * Set up the auto complete plugin
                 */

                $('#LOOPER_NAMES').autocomplete({
                    source: function(request, response) {
                        /*
                         * Take the matches based on the current term and turn it into a formatted string
                         */

                        var term = self._removeCurrentNamesFromString(request.term),
                            matches = $.ui.autocomplete.filter(self.groupUserNames, term),
                            finalMatches = [];

                        matches.forEach(function (match, index) {
                            finalMatches.push({
                                label: match,
                                value: self._stringByIncludingAllCurrentNames(true) + match
                            });
                        });

                        if (term.length > 2) response(finalMatches);
                    },

                    select: function(event, ui) {
                        self.names.push(ui.item.label);

                        event.preventDefault();
                        self._updateInputToCurrentNameList();
                    }
                });
            });
        },

        /*
         * When called, it will check to see if a completed name is in the string that is not already in this.names
         */

        checkForCompletedName: function(event) {
            var term = this._removeCurrentNamesFromString($('#LOOPER_NAMES').val());
                self = this;

            this.groups.forEach(function(user, index) {
                if (term == user.name.toLowerCase()) {
                    self.names.push(user.name);
                    $('#LOOPER_NAMES').autocomplete("close");

                    self._updateInputToCurrentNameList();
                    event.preventDefault();
                }
            });
        },

        /*
         * Checks to see if the current input text has removed a name that is in the this.names array
         */

        checkForDeletedName: function() {
            var namesCopy = this.names,
                term = $('#LOOPER_NAMES').val();

            this.names.forEach(function(name, index) {
                if (term.indexOf(name) == -1) {
                    namesCopy.splice(index, 1);
                }
            });

            this.names = namesCopy;
        },

        /*
         * Takes a string and removes anything from it that is currently in this.names
         */

        _removeCurrentNamesFromString: function(string) {
            var term = $.trim(string.toLowerCase());

            this.names.forEach(function(name, index) {
                term = term.replace(',', '');
                term = $.trim(term.replace(name.toLowerCase(), ''));
            });

            return term;
        },

        /*
         * Generates a formatted string from this.names (ex. Rick Harrison, Zain Ali)
         */

        _stringByIncludingAllCurrentNames: function(includeCommaEnding) {
            var string = '';

            this.names.forEach(function(name, index) {
                string += name + ', ';
            });

            if (!includeCommaEnding) {
                string = string.substring(0, string.length - 2);
            }

            return string;
        },

        /*
         * Used to update the input area to a formatted string based on this.names
         */

        _updateInputToCurrentNameList: function() {
            $('#LOOPER_NAMES').val(this._stringByIncludingAllCurrentNames(true));
        },

        /*
         * Animate the transition from the names input to the tags input
         */

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
         * Submit the names and tags to the api
         */

        submitLoop: function() {
            //location.href
            /*
             * Match this.names to ids and graphIds from this.groups
             */

            var self = this,
                idUsers = [],
                graphIdUsers = [];

            this.names.forEach(function(name, index) {
                self.groups.forEach(function(group, index) {
                    if (name == group.name) {
                        if (group.id) {
                            idUsers.push(group.id);
                        } else if (group.graphId) {
                            graphIdUsers.push(group.graphId);
                        }
                    }
                });
            });

            /*$.ajax({
                url: 'http://looper.io/groups.json',
                type: 'POST',
                data: 'friends=[' + idUsers.join() + ']&network_friends=[' + graphIdUsers.join() + ']'
            }).done(function(data) {
                console.log(data);
            });*/

            var groups = {friends:idUsers, network_friends:graphIdUsers};
            $.post('http://looper.io/groups.json', groups, function(inData){
                var data = {share:{url:location.href, group_id:inData.id}};                               
                $.post('http://looper.io/shares.json', data, function(inData2) {
                    //console.log(inData);
                    /*$window.location.href = "#/shares"*/
                });                         
            });

            /*
             * Animate the change osut
             */

            $('#LOOPER_TAGS').animate({
                paddingLeft: '100px',
                opacity: 0
            }, {
                duration: 300,
                easing: 'swing'
            });

            $('#LOOPER_COMPLETE').css('display', 'block').animate({
                opacity: 1
            }, {
                duration: 300,
            });

            window.setTimeout(function() {
                self.hideMainContainer();
            }, 1500);
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
