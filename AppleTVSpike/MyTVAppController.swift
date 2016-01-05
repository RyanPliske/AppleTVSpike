import TVMLKit

private typealias JavascriptClosure = (JSContext) -> Void
private typealias ObjectivecCompletionBlock = @convention(block) (String) -> Void

class MyTVAppController: TVApplicationController {
    
    init(window: UIWindow?, delegate: MyTVAppControllerDelegate?) {
        super.init(context: MyTVAppController.initialContext, window: window, delegate: delegate)
        setupGameStartedListener()
        setupJavaScriptConsoleLog()
    }
    
    private static let TVBaseURL = "http://localhost:9001/"
    private static let TVBootURL = "\(MyTVAppController.TVBaseURL)js/application.js"
    
    private static var initialContext: TVApplicationControllerContext {
        let appControllerContext = TVApplicationControllerContext()
        appControllerContext.javaScriptApplicationURL = NSURL(string: MyTVAppController.TVBootURL)!
        appControllerContext.launchOptions["BASEURL"] = MyTVAppController.TVBaseURL
        return appControllerContext
    }
    
    private var consoleLog: JavascriptClosure = {
        (context: JSContext) -> Void in
        context.evaluateScript("var console = {log: function() { var message = ''; for(var i = 0; i < arguments.length; i++) { message += arguments[i] + ' ' }; console.print(message) } };")
        let objCompletion: ObjectivecCompletionBlock = {
            (str: String) -> Void in
            print(str)
        }
        context.objectForKeyedSubscript("console").setObject(unsafeBitCast(objCompletion, AnyObject.self), forKeyedSubscript:"print")
    }
    
    // This creates a function in the javascript context which can be called (using JS!) by gameStarted(str)
    private func setupGameStartedListener() {
        weak var weakSelf = self
        let gameStarted: JavascriptClosure = {
            (context: JSContext) -> Void in
            let objCompletion: ObjectivecCompletionBlock = {
                (str: String) -> Void in
                (weakSelf?.delegate as? MyTVAppControllerDelegate)?.gameDidStartWithMessage(str)
            }
            context.setObject(unsafeBitCast(objCompletion, AnyObject.self), forKeyedSubscript: "gameStarted")
        }
        evaluateInJavaScriptContext(gameStarted, completion: nil)
    }
    
    // This creates a function in the javascript context which can be called (using JS!) by console.log(str) or console.print(str)
    private func setupJavaScriptConsoleLog() {
        evaluateInJavaScriptContext(consoleLog, completion: nil)
    }
    
}