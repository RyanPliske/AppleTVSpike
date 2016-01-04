import TVMLKit

class MyTVApp: NSObject, TVApplicationControllerDelegate {
    
    var appController: MyTVApplicationController!
    
    init(window: UIWindow) {
        super.init()
        appController = MyTVApplicationController(window: window, delegate: self)
    }
    
    func appController(appController: TVApplicationController, didFailWithError error: NSError) {
        let alertController = UIAlertController(title: "Error Launching Application", message: error.localizedDescription, preferredStyle:.Alert)
        self.appController.navigationController.presentViewController(alertController, animated: true, completion: nil)
    }
    
}