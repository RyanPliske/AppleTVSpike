/*
    Ryan Pliske
    Client-Server Code for My AppleTVSpike
    To start the server you'll run this command in my 'client' folder:
    python -m SimpleHTTPServer 9001

    navigationDocument is part of TVJS: https://developer.apple.com/library/tvos/documentation/TVMLJS/Reference/TVJSFrameworkReference/
    it is analogous to a UINavigationController: pushes and pops TVML documents
*/

"use strict";

App.onLaunch = function(options) {
  var javascriptFiles = [`${options.BASEURL}js/Presenter.js`];
  var completion = function(success) {
    if(success) {
        var alert = createAlert("Hello World!", "");
        Presenter.modalDialogPresenter(alert);
    } else {
        var alert = createAlert("Something Went Wrong On Our Server.", "Error attempting to evaluate external JavaScript files.");
        navigationDocument.presentModal(alert);
    }
  }
  evaluateScripts(javascriptFiles, completion);
}

/**
 * Convenience function returns an alert template
 * https://developer.apple.com/library/tvos/documentation/LanguagesUtilities/Conceptual/ATV_Template_Guide/TextboxTemplate.html#//apple_ref/doc/uid/TP40015064-CH2-SW8
 */
var createAlert = function(title, description) {

    var alertString = `<?xml version="1.0" encoding="UTF-8" ?>
        <document>
          <alertTemplate>
            <title>${title}</title>
            <description>${description}</description>
            <button>
                <text>OK</text>
            </button>
          </alertTemplate>
        </document>`

    // DomParser converts TVML string to TVML document (popup Window)
    var parser = new DOMParser();

    var alertDoc = parser.parseFromString(alertString, "application/xml");

    return alertDoc
}