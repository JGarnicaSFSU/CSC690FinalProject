import UIKit
import GoogleMaps

// GOOGEL API KEY
let googleApiKey = "AIzaSyBxqvljaUOQb3-j0G_57fkXYQrooQA5Q-c"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        GMSServices.provideAPIKey(googleApiKey)
        return true
    }
}

