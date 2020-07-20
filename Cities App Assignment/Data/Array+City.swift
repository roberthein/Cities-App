import Foundation

typealias SearchCompletion = ([City], TimeInterval) -> Void

extension Array where Element == City {
    
    /// Use this binary search algorithm to search for cities in a sorted array.
    /// - Parameters:
    ///   - query: the city prefix to match to
    ///   - completion: a completion block executed on the main queue
    func binary(search query: String, completion: @escaping SearchCompletion) {
        
        DispatchQueue.global().async {
            let start = Date()
            let first = self.firstIndex(for: query.lowercased()) + 1
            let last = self.lastIndex(for: query.lowercased()) - 1
            let searchTime = abs(start.timeIntervalSinceNow)
            
            guard last >= first else {
                DispatchQueue.main.async {
                    completion([], searchTime)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(Array(self[first ... last]), searchTime)
            }
        }
    }
    
    /// Returns an array sorted by city first and country after.
    func alphabetical() -> [Element] {
        return sorted {
            if $0.name.lowercased() != $1.name.lowercased() {
                return $0.name.lowercased() < $1.name.lowercased()
            } else {
                return $0.country.lowercased() < $1.country.lowercased()
            }
        }
    }
}

fileprivate extension Array where Element == City {
    
    func firstIndex(for query: String) -> Int {
        var first: Int = 0
        var last: Int = count - 1
        
        while first <= last {
            let index = Int(ceil(Double(first + last) / 2))
            let name = self[index].name.lowercased()
            
            if name >= query {
                last = index - 1
            } else if name <= query {
                first = index + 1
            } else {
                return last
            }
        }
        
        return last
    }
    
    func lastIndex(for query: String) -> Int {
        var first: Int = 0
        var last: Int = count - 1
        
        while first <= last {
            let index = Int(ceil(Double(first + last) / 2))
            let name = self[index].name.lowercased()
            
            if name <= query || name.hasPrefix(query) {
                first = index + 1
            } else if name > query {
                last = index - 1
            } else {
                return first
            }
        }
        
        return first
    }
}
