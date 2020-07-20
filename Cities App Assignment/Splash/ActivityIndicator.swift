import Foundation
import UIKit

class ActivityIndicator: UIActivityIndicatorView {
    
    required init() {
        let style: UIActivityIndicatorView.Style
        
        if #available(iOS 13.0, *) {
            style = .medium
        } else {
            style = .gray
        }
        
        super.init(style: style)
        
        translatesAutoresizingMaskIntoConstraints = false
        hidesWhenStopped = true
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        startAnimating()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
