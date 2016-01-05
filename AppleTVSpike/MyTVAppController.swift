import TVMLKit

private typealias JavascriptClosure = (JSContext) -> Void
private typealias ObjectivecCompletionBlock = @convention(block) (String) -> Void

private let TVBaseURL = "http://localhost:9001/"

class MyTVAppController: TVApplicationController {
    
    init(window: UIWindow?, delegate: MyTVAppControllerDelegate?) {
        let appControllerContext = TVApplicationControllerContext()
        appControllerContext.javaScriptApplicationURL = NSURL(string: "\(TVBaseURL)js/application.js")!
        appControllerContext.launchOptions["BASEURL"] = TVBaseURL
        super.init(context: appControllerContext, window: window, delegate: delegate)
    }
    
    // This creates a function on your server which can be called using JS by gameStarted(str)
    func setupGameStartedListener() {
        let gameStarted: JavascriptClosure = {
            [unowned self](context: JSContext) -> Void in
            let objCompletion: ObjectivecCompletionBlock = {
                (str: String) -> Void in
                (self.delegate as? MyTVAppControllerDelegate)?.gameDidStartWithMessage(str)
            }
            context.setObject(unsafeBitCast(objCompletion, AnyObject.self), forKeyedSubscript: "gameStarted")
        }
        evaluateInJavaScriptContext(gameStarted, completion: nil)
    }
    
    // This creates a function on your server which can be called using JS by console.log(str)
    func setupJavaScriptConsoleLog() {
        let consoleLog: JavascriptClosure = {
            (context: JSContext) -> Void in
            context.evaluateScript("var console = {log: function() { var message = ''; for(var i = 0; i < arguments.length; i++) { message += arguments[i] + ' ' }; console.print(message) } };")
            let objCompletion: ObjectivecCompletionBlock = {
                (str: String) -> Void in
                print("⛔️" + str)
            }
            context.objectForKeyedSubscript("console").setObject(unsafeBitCast(objCompletion, AnyObject.self), forKeyedSubscript:"print")
        }
        evaluateInJavaScriptContext(consoleLog, completion: nil)
    }
    
}