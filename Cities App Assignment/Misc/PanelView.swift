import Foundation
import UIKit

class PanelView: UIView {
    
    required init(color: UIColor) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = color
        layer.cornerRadius = Metrics.panelCornerRadius
        
        layer.borderColor = UIColor.foreground.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1 / UIScreen.main.scale
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

