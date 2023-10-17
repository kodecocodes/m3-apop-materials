//: A UIKit based Playground for presenting user interface
  
import UIKit
import SwiftUI
import PlaygroundSupport


protocol MediaCollection {
    associatedtype Item: MediaItem
    var items: [Item] { get set }
    func getDescription() -> String
}

extension MediaCollection {
    func getDescription() -> String {
        "Collection contains \(items.count) items"
    }
}

protocol MediaItem: Identifiable {
    var title: String { get }
    var price: Double { get }
}

protocol Video: MediaItem {
    var duration: TimeInterval { get }
}

struct Movie: Video {
    let id: UUID
    let title: String
    let price: Double
    let duration: TimeInterval
}

struct TVShow: Video {
    let id: UUID
    let title: String
    let price: Double
    let duration: TimeInterval
}

enum Console {
    case xbox
    case playstation
    case `switch`
}

struct VideoGame: MediaItem {
    let id: UUID
    let title: String
    let price: Double
    let console: Console
}

class MediaShelf<T: MediaItem>: MediaCollection {
    var items: [T] = []
}

extension MediaCollection {
    mutating func add(_ item: Item) {
        self.items.append(item)
    }
}

extension MediaShelf where T == VideoGame {
    func getDescription() -> String {
        let xboxCount = items.filter({ $0.console == .xbox }).count
        let playstationCount = items.filter({ $0.console == .playstation }).count
        let switchCount = items.filter({ $0.console == .switch }).count
        return "This collection contains \(xboxCount) Xbox games, \(playstationCount) Playstation games and \(switchCount) Switch games"
    }
}

struct BoardGame: MediaItem {
    let id: UUID
    var title: String
    let price: Double
}

let catan = BoardGame(id: UUID(), title: "Catan", price: 40)
let arkhamKnight = VideoGame(id: UUID(), title: "Batman: Arkham Knight", price: 49.99, console: .xbox)
let tearsOfTheKingdom = VideoGame(id: UUID(), title: "The Legend of Zelda: Tears of the Kingdom", price: 59.99, console: .switch)
let noTimeToDie = Movie(id: UUID(), title: "No Time To Die", price: 19.99, duration: 163)

var boardGameShelf = MediaShelf<BoardGame>()
var movieShelf = MediaShelf<Movie>()
var videoGameShelf = MediaShelf<VideoGame>()
boardGameShelf.add(catan)
movieShelf.add(noTimeToDie)
videoGameShelf.add(arkhamKnight)
videoGameShelf.add(tearsOfTheKingdom)

let view = MediaCollectionView<VideoGame>(repository: VideoGameMediaRepository())
PlaygroundPage.current.setLiveView(view.frame(width: 375, height: 667))

struct MediaCollectionView<T: MediaItem & Identifiable & View>: MediaCollection & View {
    
    let repository: any MediaRepository
    @State var items: [T] = []
    
    var body: some View {
        List(items) {
            $0
        }
        .task {
            self.items = try! await repository.getItems() as! [T]
        }
        .refreshable {
            self.items = try! await repository.getItems() as! [T]
        }
    }
}

extension MediaItem {
    var body: some View {
        Text(self.title)
    }
}

extension VideoGame: View {}

protocol MediaRepository {
    associatedtype Item: MediaItem & Identifiable & View
    
    func getItems() async throws -> [Item]
}

struct VideoGameMediaRepository: MediaRepository {
    func getItems() async throws -> [VideoGame] {
        [arkhamKnight, tearsOfTheKingdom].shuffled()
    }
}
