import TVMLKit

typealias LogBlock = @convention(block) (String) -> Void

class MyTVApplicationController: TVApplicationController {
    
    static let TVBaseURL = "http://localhost:9001/"
    static let TVBootURL = "\(MyTVApplicationController.TVBaseURL)js/application.js"
    static var context: TVApplicationControllerContext {
        let appControllerContext = TVApplicationControllerContext()
        appControllerContext.javaScriptApplicationURL = NSURL(string: MyTVApplicationController.TVBootURL)!
        appControllerContext.launchOptions["BASEURL"] = MyTVApplicationController.TVBaseURL
        return appControllerContext
    }
    
    private typealias GameStarted = (JSContext) -> Void
    
    init(window: UIWindow?, delegate: TVApplicationControllerDelegate?) {
        super.init(context: MyTVApplicationController.context, window: window, delegate: delegate)
        setupGameStartedListener()
    }
    
    private func setupGameStartedListener() {
        let gameStarted: GameStarted = {
            (evaluation: JSContext) -> Void in
            let log: LogBlock = {
                (str : String) -> Void in
                print(str)
            }
            //this creates a function in the javascript context called "swiftPrint".
            //calling swiftPrint(str) in javascript will call the block we created above.
            evaluation.setObject(unsafeBitCast(log, AnyObject.self), forKeyedSubscript: "gameStarted")
        }
        self.evaluateInJavaScriptContext(gameStarted, completion: nil)
    }
    
}