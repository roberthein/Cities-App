import Foundation
import UIKit
import MapKit

class MapView: MKMapView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        mapType = .mutedStandard
        clipsToBounds = true
        layer.cornerRadius = Metrics.panelCornerRadius
        layer.borderColor = UIColor.foreground.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1 / UIScreen.main.scale
        delegate = self
        
        register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: "AnnotationView")
        
        goTo(.home, delta: 100, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goTo(_ location: CLLocationCoordinate2D, delta: Double, animated: Bool) {
        let degreeSpan = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: location, span: degreeSpan)
        
        setRegion(region, animated: animated)
    }
    
    func goTo(_ annotation: MKPointAnnotation) {
        removeAnnotations(annotations)
        addAnnotation(annotation)
        
        goTo(annotation.coordinate, delta: .random(in: 0.1 ... 0.3), animated: true)
    }
}
