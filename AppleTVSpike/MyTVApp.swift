import TVMLKit

class MyTVApp: NSObject, TVApplicationControllerDelegate {
    
    var appController: MyTVApplicationController
    
    init(tvAppController: MyTVApplicationController) {
        appController = tvAppController
        super.init()
    }
    
    func appController(appController: TVApplicationController, didFailWithError error: NSError) {
        let alertController = UIAlertController(title: "Error Launching Application", message: error.localizedDescription, preferredStyle:.Alert)
        self.appController.navigationController.presentViewController(alertController, animated: true, completion: nil)
    }
    
}