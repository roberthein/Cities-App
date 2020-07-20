import Foundation

enum CitiesResult {
    case success([City])
    case failure(Error)
}

typealias CitiesLoadCompletion = (CitiesResult) -> Void

struct Cities {
    
    static func load(_ resource: String = "Cities", completion: @escaping CitiesLoadCompletion) {
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            return
        }
        
        DispatchQueue.global().async {
            do {
                /// Load the resource into a Data object.
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                /// Parse the data into an array of City objects.
                let cities = try JSONDecoder().decode([City].self, from: data)
                
                /// Sort the array to be able to apply binary search.
                let sorted = cities.alphabetical()
                
                DispatchQueue.main.async {
                    completion(.success(sorted))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
