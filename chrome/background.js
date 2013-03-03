chrome.browserAction.onClicked.addListener(function(tab) {
    chrome.tabs.executeScript(tab.id, { file: 'js/jquery.min.js' }, function() {
        chrome.tabs.executeScript(tab.id, { file: 'js/jquery-ui.min.js' }, function() {
            chrome.tabs.executeScript(tab.id, { file: 'looper.js' });
        });
    });
});
