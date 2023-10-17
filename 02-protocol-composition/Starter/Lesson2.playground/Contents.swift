import Foundation

protocol MediaItem {
    var title: String { get }
    var price: Double { get set }
}

protocol MediaCollection {
    associatedtype Item: MediaItem
    var items: [Item] { get set }
    func getDescription() -> String
}

enum Console {
    case xbox
    case playstation
    case `switch`
}

struct VideoGame: MediaItem {
    let title: String
    var price: Double
    let console: Console
}

struct Movie: MediaItem {
    let title: String
    var price: Double
    let duration: Int
}

struct TVShow: MediaItem {
    let title: String
    var price: Double
    let duration: Int
}

struct BoardGame: MediaItem {
    let title: String
    var price: Double
}

struct CardGame {
    let title: String
}
