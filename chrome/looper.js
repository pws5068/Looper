/*
 * Create the stylesheet
 */

var css = document.createElement("link")
css.setAttribute("rel", "stylesheet")
css.setAttribute("type", "text/css")
css.setAttribute("href", chrome.extension.getURL('looper.css'));

document.getElementsByTagName('body')[0].appendChild(css);

/*
 * Read in the main html
 */

var xhr = new XMLHttpRequest();
xhr.open("GET", chrome.extension.getURL('looper.html'), true);
xhr.onreadystatechange = function() {
    if (xhr.readyState == 4) {
        document.body.innerHTML += xhr.response;

        $('#LOOPER_MAIN').css('top', '-1' + $('#LOOPER_MAIN').css('height'))
        .animate({
            top: '0px'
        }, {
            duration:500
        });
    }
};
xhr.send();