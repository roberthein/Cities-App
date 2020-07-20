import Foundation
import MapKit

typealias FilterCompletion = (TimeInterval) -> Void

class ListViewModel {
    
    let cities: [City]
    var filteredCities: [City] = []
    
    init(with cities: [City]) {
        self.cities = cities
        self.filteredCities = cities
    }
    
    var numberOfCities: Int {
        return filteredCities.count
    }
    
    func city(for indexPath: IndexPath) -> City {
        return filteredCities[indexPath.row]
    }
    
    func subtitle(for city: City) -> String {
        return String(format: "%.4f - %.4f", abs(city.location.coordinate.latitude), abs(city.location.coordinate.longitude))
    }
    
    func timeString(for time: TimeInterval) -> String {
        return String(format: "Time spent searching: %.3fms", time * 1000)
    }
    
    func filter(_ query: String, completion: @escaping FilterCompletion) {
        
        cities.binary(search: query) { [weak self] cities, time  in
            self?.filteredCities = cities
            completion(time)
        }
    }
    
    func annotation(for city: City) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "\(city.name), \(city.country)"
        annotation.coordinate = city.location.coordinate
        
        return annotation
    }
}
