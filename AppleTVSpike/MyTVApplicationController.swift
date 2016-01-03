import TVMLKit

typealias LogBlock = @convention(block) (String) -> Void

class MyTVApplicationController: TVApplicationController {
    
    private typealias GameStarted = (JSContext) -> Void
    
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
        setupGameStartedListener()
    }
    
    // This creates a function in the javascript context called "gameStarted".
    // Calling gameStarted(str) in javascript will call the log block.
    private func setupGameStartedListener() {
        let gameStarted: GameStarted = {
            (evaluation: JSContext) -> Void in
            let log: LogBlock = {
                (str: String) -> Void in
                print(str)
            }
            evaluation.setObject(unsafeBitCast(log, AnyObject.self), forKeyedSubscript: "gameStarted")
        }
        self.evaluateInJavaScriptContext(gameStarted, completion: nil)
    }
    
}