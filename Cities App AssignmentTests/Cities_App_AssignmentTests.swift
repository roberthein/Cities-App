@testable import Cities_App_Assignment
import XCTest

class Cities_App_AssignmentTests: XCTestCase {
    
    private var cities: [City]!
    
    override func setUp() {
        super.setUp()
        
        let exp = expectation(description: "")
        
        Cities.load("Mock") { result in
            switch result {
                case .success(let cities):
                    self.cities = cities
                case .failure(let error):
                    error.handle()
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5)
        XCTAssertEqual(cities.count, 5)
    }
    
    override func tearDown() {
        cities = nil
        super.tearDown()
    }
    
    func test_prefix_a() {
        let exp = expectation(description: "")
        
        cities.binary(search: "a") { cities, _ in
            XCTAssertEqual(cities.count, 4)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_prefix_s() {
        let exp = expectation(description: "")
        
        cities.binary(search: "s") { cities, _ in
            XCTAssertEqual(cities.count, 1)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_prefix_al() {
        let exp = expectation(description: "")
        
        cities.binary(search: "al") { cities, _ in
            XCTAssertEqual(cities.count, 2)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_prefix_alb() {
        let exp = expectation(description: "")
        
        cities.binary(search: "alb") { cities, _ in
            XCTAssertEqual(cities.count, 1)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_invalid_input() {
        let exp = expectation(description: "")
        
        cities.binary(search: "xxxx") { cities, _ in
            XCTAssertEqual(cities.count, 0)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
}
