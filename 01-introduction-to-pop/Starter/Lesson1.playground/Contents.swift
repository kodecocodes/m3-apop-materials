import Foundation

protocol Vehicle {
    var numberOfWheels: Int { get }
    var maxSpeed: Double { get }
    var totalDistanceTraveled: Double { get set }
    func showDetails() -> String
    func move(direction: Direction, duration: TimeInterval, speed: Double)
}

enum Direction {
    case forward
    case backwards
}

class FamilyCar: Vehicle {
    let maxSpeed: Double
    let numberOfWheels: Int
    var totalDistanceTraveled: Double
    
    init() {
        self.maxSpeed = 50.0
        self.numberOfWheels = 4
        self.totalDistanceTraveled = 0.0
    }
    
    func move(direction: Direction, duration: TimeInterval, speed: Double) {

    }
    
    func showDetails() -> String {
        "I am a family car"
    }
}

open class VehicleType {
    let numberOfWheels: Int
    var maxSpeed: Double
    var totalDistanceTraveled: Double
    
    init() {
        self.numberOfWheels = 4
        self.maxSpeed = 100
        self.totalDistanceTraveled = 0.0
    }
    
    func move(direction: Direction, duration: TimeInterval, speed: Double) {

    }
    
    func showDetails() -> String {
        "I am a vehicle"
    }
}

class FamilyCarInheritance: VehicleType {
    let carMaxSpeed = 50.0
    override var maxSpeed: Double {
        get {
            return carMaxSpeed
        }
        set {
            // Do nothing
        }
    }

    override func move(direction: Direction, duration: TimeInterval, speed: Double) {
        super.move(direction: direction, duration: duration, speed: speed)
        print("Current distance is \(totalDistanceTraveled)")
    }

    override func showDetails() -> String {
        "I am a family car"
    }
}
