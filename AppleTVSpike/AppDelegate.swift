import UIKit
import TVMLKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TVApplicationControllerDelegate {

    var window: UIWindow?
    var appController: MyTVApplicationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        appController = MyTVApplicationController(window: window, delegate: self)
        return true
    }
    
    // MARK: TVApplicationControllerDelegate
    
    func appController(appController: TVApplicationController, didFailWithError error: NSError) {
        let alertController = UIAlertController(title: "Error Launching Application", message: error.localizedDescription, preferredStyle:.Alert)
        self.appController?.navigationController.presentViewController(alertController, animated: true, completion: nil)
    }

}

