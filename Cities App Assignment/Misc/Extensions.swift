import Foundation
import UIKit
import CoreLocation

extension Error {
    
    func handle() {
        let nserror = self as NSError
        
        print("Error:", nserror.userInfo)
        
        let alert = UIAlertController(title: "Error", message: "\(nserror.userInfo)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        
        let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        rootViewController?.present(alert, animated: true, completion: nil)
    }
}

extension CLLocationCoordinate2D {
    
    static var home = CLLocationCoordinate2D(latitude: 52.221146, longitude: 5.3341248)
}
