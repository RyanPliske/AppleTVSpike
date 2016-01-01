import TVMLKit

class MyTVApplicationController: TVApplicationController {
    
    static let TVBaseURL = "http://localhost:9001/"
    static let TVBootURL = "\(MyTVApplicationController.TVBaseURL)js/application.js"
    static var context: TVApplicationControllerContext {
        let appControllerContext = TVApplicationControllerContext()
        appControllerContext.javaScriptApplicationURL = NSURL(string: MyTVApplicationController.TVBootURL)!
        appControllerContext.launchOptions["BASEURL"] = MyTVApplicationController.TVBaseURL
        return appControllerContext
    }
    
    init(window: UIWindow?, delegate: TVApplicationControllerDelegate?) {
        super.init(context: MyTVApplicationController.context, window: window, delegate: delegate)
    }
    
}