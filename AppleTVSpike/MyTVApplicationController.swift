import TVMLKit

private typealias JavascriptClosure = (JSContext) -> Void
private typealias ObjectivecCompletionBlock = @convention(block) (String) -> Void

class MyTVApplicationController: TVApplicationController {
    
    init(window: UIWindow?, delegate: TVApplicationControllerDelegate?) {
        super.init(context: MyTVApplicationController.initialContext, window: window, delegate: delegate)
        setupGameStartedListener()
        setupJavaScriptConsoleLog()
    }
    
    private static let TVBaseURL = "http://localhost:9001/"
    private static let TVBootURL = "\(MyTVApplicationController.TVBaseURL)js/application.js"
    
    private static var initialContext: TVApplicationControllerContext {
        let appControllerContext = TVApplicationControllerContext()
        appControllerContext.javaScriptApplicationURL = NSURL(string: MyTVApplicationController.TVBootURL)!
        appControllerContext.launchOptions["BASEURL"] = MyTVApplicationController.TVBaseURL
        return appControllerContext
    }
    
    private var gameStarted: JavascriptClosure = {
        (context: JSContext) -> Void in
        let objCompletion: ObjectivecCompletionBlock = {
            (str: String) -> Void in
            print(str)
        }
        context.setObject(unsafeBitCast(objCompletion, AnyObject.self), forKeyedSubscript: "gameStarted")
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
        evaluateInJavaScriptContext(gameStarted, completion: nil)
    }
    
    // This creates a function in the javascript context which can be called (using JS!) by console.log(str)
    private func setupJavaScriptConsoleLog() {
        evaluateInJavaScriptContext(consoleLog, completion: nil)
    }
    
}