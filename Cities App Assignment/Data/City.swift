import Foundation
import CoreLocation

struct City: Codable, Hashable {
    var id: Int
    var name: String
    var country: String
    
    private var coord: [String: Double]
    
    var location: CLLocation {
        return CLLocation(latitude: coord["lat"]!, longitude: coord["lon"]!)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case country
        case coord
    }
}
