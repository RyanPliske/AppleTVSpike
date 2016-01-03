import UIKit
import TVMLKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TVApplicationControllerDelegate {

    var window: UIWindow?
    var appController: MyTVApplicationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        appController = MyTVApplicationController(window: window, delegate: self)
        createSwiftPrint()
        return true
    }
    
    // MARK: TVApplicationControllerDelegate
    
    func appController(appController: TVApplicationController, didFailWithError error: NSError) {
        print("\(__FUNCTION__) invoked with error: \(error)")
        
        let title = "Error Launching Application"
        let message = error.localizedDescription
        let alertController = UIAlertController(title: title, message: message, preferredStyle:.Alert)
        self.appController?.navigationController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func appController(appController: TVApplicationController, evaluateAppJavaScriptInContext jsContext: JSContext) {
        jsContext.evaluateScript("var console = {log: function() { var message = ''; for(var i = 0; i < arguments.length; i++) { message += arguments[i] + ' ' }; console.print(message) } };")
        let logFunction: @convention(block) (NSString!) -> Void = { (message:NSString!) in
            print("JS: \(message)")
        }
        jsContext.objectForKeyedSubscript("console").setObject(unsafeBitCast(logFunction, AnyObject.self), forKeyedSubscript:"print")
    }
    
    func appController(appController: TVApplicationController, didStopWithOptions options: [String: AnyObject]?) {
        print("\(__FUNCTION__) invoked with options: \(options)")
    }
    
    private func createSwiftPrint(){
        
        appController?.evaluateInJavaScriptContext({(evaluation: JSContext) -> Void in
            
            //this is the block that will be called when javascript calls swiftPrint(str)
            let swiftPrintBlock : @convention(block) (String) -> Void = {
                (str : String) -> Void in
                print(str)
            }
            
            //this creates a function in the javascript context called "swiftPrint".
            //calling swiftPrint(str) in javascript will call the block we created above.
            evaluation.setObject(unsafeBitCast(swiftPrintBlock, AnyObject.self), forKeyedSubscript: "swiftPrint")
            }, completion: {(Bool) -> Void in
                //evaluation block finished running
        })
    }

}

