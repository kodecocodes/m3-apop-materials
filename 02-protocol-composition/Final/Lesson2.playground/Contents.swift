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

struct BoardGame: MediaItem, Codable {
    let title: String
    var price: Double
}

struct CardGame {
    let title: String
}

struct MovieCollection: MediaCollection {
    typealias Item = Movie
    var items: [Movie] = []
}

let bourneIdentity = Movie(title: "The Bourne Identity", price: 3.99, duration: 113)
let oppenheimer = Movie(title: "Oppenheimer", price: 17.99, duration: 180)

var movieCollection = MovieCollection()
movieCollection.add(bourneIdentity)
movieCollection.add(oppenheimer)

print(movieCollection.getDescription())

extension MediaCollection {
    mutating func add(_ item: Item) {
        self.items.append(item)
    }
    
    func getDescription() -> String {
        "Collection contains \(items.count) items"
    }
}

struct MediaShelf<T: MediaItem>: MediaCollection, RandomEntertainmentPicker {
    var items: [T] = []
    
    func getItemToEnjoy() -> T? {
        items.randomElement()
    }
}

let catan = BoardGame(title: "Catan", price: 40)
let arkhamKnight = VideoGame(title: "Batman: Arkham Knight", price: 49.99, console: .xbox)
let tearsOfTheKingdom = VideoGame(title: "The Legend of Zelda: Tears of the Kingdom", price: 59.99, console: .switch)
let noTimeToDie = Movie(title: "No Time To Die", price: 19.99, duration: 163)

var boardGameShelf = MediaShelf<BoardGame>()
var movieShelf = MediaShelf<Movie>()
var videoGameShelf = MediaShelf<VideoGame>()
boardGameShelf.add(catan)
movieShelf.add(noTimeToDie)
videoGameShelf.add(arkhamKnight)
videoGameShelf.add(tearsOfTheKingdom)

print(boardGameShelf.getDescription())
print(movieShelf.getDescription())
print(videoGameShelf.getDescription())

extension MediaShelf where T == VideoGame {
    func getDescription() -> String {
        let xboxCount = items.filter({ $0.console == .xbox }).count
        let playstationCount = items.filter({ $0.console == .playstation }).count
        let switchCount = items.filter({ $0.console == .switch }).count
        return "This collection contains \(xboxCount) Xbox games, \(playstationCount) Playstation games and \(switchCount) Switch games"
    }
}

extension MediaShelf where T: Codable {
    func printItems() throws {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(items)
        if let string = String(data: data, encoding: .utf8) {
            print(string)
        }
    }
}

try boardGameShelf.printItems()

protocol RandomEntertainmentPicker {
    associatedtype Item
    func getItemToEnjoy() -> Item?
}

print("Let's play \(videoGameShelf.getItemToEnjoy()?.title ?? "Nothing!")")

func printItemDetails(_ item: MediaItem & Codable) throws {
    let jsonEncoder = JSONEncoder()
    let data = try jsonEncoder.encode(item)
    if let string = String(data: data, encoding: .utf8) {
        print(string)
    }
}

try printItemDetails(catan)

struct CardGames: RandomEntertainmentPicker {
    let games: [CardGame]
    
    func getItemToEnjoy() -> CardGame? {
        return games.randomElement()
    }
}

let bridge = CardGame(title: "Bridge")
let solitaire = CardGame(title: "Solitaire")

let cardGames = CardGames(games: [bridge, solitaire])
guard let cardGameToPlay = cardGames.getItemToEnjoy() else {
    fatalError("We have no card games!")
}
print("We have some cards so we'll play \(cardGameToPlay.title)")
