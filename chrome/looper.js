$('#LOOPER_CONTAINER').remove();

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
        container.innerHTML += xhr.response;

        $('#LOOPER_LOGO').attr('src', chrome.extension.getURL('images/looper_logo.png'));

        $('#LOOPER_MAIN').css('top', '-1' + $('#LOOPER_MAIN').css('height'))
        .animate({
            top: '0px'
        }, {
            duration:500
        });
    }
};
xhr.send();