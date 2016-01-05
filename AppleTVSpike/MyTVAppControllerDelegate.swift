import TVMLKit

protocol MyTVAppControllerDelegate: class, TVApplicationControllerDelegate {
    
    func gameDidStartWithMessage(message: String)
    
}