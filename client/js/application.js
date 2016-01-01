/*
    Ryan Pliske
    Client-Server Code for My AppleTVSpike
*/

"use strict";

App.onLaunch = function(options) {
  var alert = createAlert("Hello World", "");
  // navigationDocument is part of TVJS: https://developer.apple.com/library/tvos/documentation/TVMLJS/Reference/TVJSFrameworkReference/
  // it is analogous to a UINavigationController: pushes and pops TVML documents
  navigationDocument.presentModal(alert);
}

/**
 * Convenience function returns an alert template
 */
var createAlert = function(title, description) {

    var alertString = `<?xml version="1.0" encoding="UTF-8" ?>
        <document>
          <alertTemplate>
            <title>${title}</title>
            <description>${description}</description>
          </alertTemplate>
        </document>`

    var parser = new DOMParser();

    var alertDoc = parser.parseFromString(alertString, "application/xml");

    return alertDoc
}