import TVMLKit

class MyTVApp: NSObject, MyTVAppControllerDelegate {
    
    var appController: MyTVAppController!
    
    init(window: UIWindow) {
        super.init()
        appController = MyTVAppController(window: window, delegate: self)
    }
    
    func appController(appController: TVApplicationController, didFailWithError error: NSError) {
        let alertController = UIAlertController(title: "Error Launching Application", message: error.localizedDescription, preferredStyle:.Alert)
        self.appController.navigationController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func appController(appController: TVApplicationController, didFinishLaunchingWithOptions options: [String : AnyObject]?) {
        self.appController.setupGameStartedListener()
        self.appController.setupJavaScriptConsoleLog()
    }
    
    func gameDidStartWithMessage(message: String) {
        print(message)
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.blueColor()
        self.appController.navigationController.presentViewController(viewController, animated: true, completion: nil)
    }
    
}