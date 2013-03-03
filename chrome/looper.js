(function(window, document, undefined)  {

    var Looper = {
        initIfNeeded: function() {
            var container = $('#LOOPER_CONTAINER');
            
            if (container.length > 0) {
                Looper.hideMainContainer();
            } else {
                Looper.init();
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
                            hideMainContainer();
                        }
                    });
                }
            };
            xhr.send();
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

    Looper.initIfNeeded();

})(window, document);
