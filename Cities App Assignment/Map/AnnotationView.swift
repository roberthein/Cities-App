import Foundation
import UIKit
import MapKit

class AnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.tint.withAlphaComponent(0.3)
        layer.cornerRadius = Metrics.annotationRadius
        layer.borderColor = UIColor.tint.cgColor
        layer.borderWidth = 1
        
        let centerView = UIView()
        centerView.translatesAutoresizingMaskIntoConstraints = false
        centerView.backgroundColor = .tint
        centerView.layer.cornerRadius = Metrics.annotationRadius / 4
        addSubview(centerView)
        
        NSLayoutConstraint.activate([
            centerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerView.widthAnchor.constraint(equalToConstant: Metrics.annotationRadius / 2),
            centerView.heightAnchor.constraint(equalToConstant: Metrics.annotationRadius / 2),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
