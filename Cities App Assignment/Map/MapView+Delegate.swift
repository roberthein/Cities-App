import Foundation
import UIKit
import MapKit

extension MapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation, let view = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView") else {
            return nil
        }
        
        view.annotation = annotation
        view.frame = CGRect(x: -Metrics.annotationRadius, y: -Metrics.annotationRadius, width: Metrics.annotationRadius * 2, height: Metrics.annotationRadius * 2)
        
        return view
    }
    
    
}
