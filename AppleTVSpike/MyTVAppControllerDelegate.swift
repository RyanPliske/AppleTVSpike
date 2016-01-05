import TVMLKit

protocol MyTVAppControllerDelegate: TVApplicationControllerDelegate {
    
    func gameDidStartWithMessage(message: String)
    
}