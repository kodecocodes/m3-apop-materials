```metadata
number: "4"
title: "Lesson 2: Protocol Design and Composition"
section: 4
free: true
authors:
  # These are applied on a per-chapter basis. If you would like to apply a role to the entire
  # book (i.e. every chapter), use the authors attribute in publish.yaml.
  # Roles: fpe, editor, tech_editor, author, illustrator
  # Use your rw.com username.
  - username: 0xTim
    role: author
description: |
  In this lesson, you'll learn how to define protocols for different scenarios and pass around types as protocols.
```

# Lesson 5: Protocol Design and Composition

## Introduction

Protocols in Swift and interfaces in Kotlin are not just programming constructs; they're powerful tools that empower you to write code that's not only flexible but also follows best practices in software development. They're more flexible than inheritance and provide a way to work with the same type for different use cases.

In this lesson, you'll dive deeper into advanced features of protocols in Swift, such as composition and default implementations. These capabilities will let you work with different types in a unified manner and create code that's easy to maintain. You'll see how to pass around types as protocols, use associated types to gain the flexibility of working with generic data types and extend protocols for added functionality.

By the end of this lesson, you'll have a comprehensive understanding of how to harness the full potential of protocols in Swift, allowing you to write clean, modular and highly adaptable code. 

## Protocol Design

When designing your protocols, you should consider how you want to use the types that conform to that protocol. One of the great things about protocols is that you can conform a type to multiple protocols. This allows you to keep your protocols narrow in scope and design them only for that particular use case.

Conforming to protocols is not only limited to classes, either. You can conform structs and even enums to protocols as well. This allows you to use the best type for the job and choose between value and reference semantics where it makes sense.

### Associated Types

When creating a protocol, you might encounter scenarios where you don't know which specific type will be used in the protocol. To accommodate this, you'll want to keep the protocol generic and allow the implementers to use different types. This is where associated types come into play.

To provide a generic type in a protocol, you use an **associated type** — a placeholder for a type that will be provided by the implementer. You can then use this type in your protocol as if it were a real type.

A classic example of when to use an associated type is a protocol that contains some sort of collection. You don't want to enforce *what* you're going to collect, but you need a way to represent and refer to that type.

For example, imagine you're building an app to catalog all the media in your house. First, you might define a protocol for a `MediaItem`:

```swift
protocol MediaItem {
    var title: String { get }
    var price: Double { get set }
}
```

This protocol defines two properties: a read-only `title` and a mutable `price`. You could use this to represent anything from books to movies to video games. Then, you can define a protocol for a `MediaCollection`:

```swift
// 1
protocol MediaCollection {
    // 2
    associatedtype Item: MediaItem
    // 3
    var items: [Item] { get set }
    // 4
    func getDescription() -> String
}
```

This code defines the following:

1. A protocol called `MediaCollection` that represents a collection of similar media items, such as a collection of movies.
2. An associated type, `Item`, for the protocol to use. Ensure that `Item` conforms to `MediaItem` so that any implementer of `MediaCollection`'s can use the API defined in `MediaItem`.
3. An array of `Item`s called `items`, which the collection will contain. This is where you use the associated type; it allows you to leave the type in the array unspecified until a type conforms to the protocol.
4. A simple function, `getDescription()`, which returns a string.

Now that you've learned about associated types, you'll explore a practical demonstration that puts this knowledge into action.  

## Demo

Now, it's time to see how to implement a `MediaCollection`. Open the starter project playground for this lesson in Xcode. `MediaItem` and `MediaCollection` are already defined for you.

A few media types have also been defined for you, such as `Movie`, `TVShow` and `VideoGame`. These all conform to `MediaItem` and have a `title` and a `price` property. Some also have an additional `duration`, where appropriate. There's also a `CardGame` for you to use later in the lesson.

First, create a collection for your movies:

```swift
struct MovieCollection: MediaCollection {

}
```

This collection will contain `Movie`s as the `Item`. To satisfy the compiler, use `typealias` to define the associated type:

```swift
typealias Item = Movie
```

Then, define the array of `items`:

```swift
var items: [Movie] = []
```

Finally, implement `getDescription()`:

```swift
func getDescription() -> String {
    "The movie collection contains \(items.count) movies"
}
```

Because you specify the type of `Item` in the `items` array, you can even remove the type alias; the compiler will infer it for you.

[Remove type alias and show working]

Most of the time, you want to keep the type alias, however, so your code is more readable.

[Undo the change]

Finally, create a couple of movies and add them to the collection, then print the description:

```swift
let bourneIdentity = Movie(title: "The Bourne Identity", price: 3.99, duration: 113)
let oppenheimer = Movie(title: "Oppenheimer", price: 17.99, duration: 180)

var movieCollection = MovieCollection()
movieCollection.items.append(bourneIdentity)
movieCollection.items.append(oppenheimer)

print(movieCollection.getDescription())
```

In this demo, you implemented a `MovieCollection` conforming to the `MediaCollection` protocol, demonstrating the practical application of associated types. Here are the steps you followed:

* First, you defined the `MovieCollection` struct to represent a collection of movies, specifying `Movie` as the associated `Item` type using a typealias.
* Then, you created an array of `Movie` items to hold the collection's content.
* Finally, you implemented the `getDescription()` function, which counts the movies in the collection and returns a descriptive message.

This demo showcases how associated types allow you to work with generic data types while preserving the safety and structure of protocols. 

## Protocol Extensions

You've now seen how to build and use relatively complex protocols. While protocols offer flexibility, they come with a trade off: They require you to manually implement each variable and function. Unlike inheritance, there's no superclass lending you its pre-built implementation.

In the media collection example, this would mean that every `MediaCollection` implementation would need a `getDescription()` function. This is likely to be almost the same for every collection type — you're going to print the number of items in that collection.

Implementing this for every collection type is a lot of duplicated code that you would need to update if the protocol ever changes. Fortunately, there is a better way!

Swift allows you to extend protocols to provide additional computed properties and function implementations. This is extremely handy for providing useful functions for all implementations of a protocol. It also allows you to provide a default implementation for a required function, so the implementer doesn't need to implement it themselves. This cuts down on duplicated code and also allows you to add functions to protocols without breaking existing code (because the existing implementations will use the default implementation).

The compiler uses the default implementation unless the type implements the function itself — in which case, the compiler uses that implementation instead. This allows you to have default implementations and override it in your types if needed, much like with inheritance.

## Generics and Protocols

Protocols also integrate nicely with generics in Swift. With protocol extensions, you can remove the duplicated code for `getDescription()`. However, there's even more room for improvement. Each type of media collection is going to be pretty similar, with the only real difference being the associated type.

Using generics along with protocols allows you to write a single implementation of `MediaCollection` that can be used for any type of media.

## Demo

Head back to Xcode to see how this works. First, create an extension on `MediaCollection`:

```swift
extension MediaCollection {

}
```

Then, define a function to make it easy to add items to that collection:

```swift
mutating func add(_ item: Item) {
    self.items.append(item)
}
```

Since the compiler knows that `MediaCollection` has an associated type of `Item`, you can use that in the extension.

Next, use the new helper function and change the code where you add movies to the collection:

```swift
movieCollection.add(bourneIdentity)
movieCollection.add(oppenheimer)
```

Next, add a default implementation for `getDescription()`:

```swift
func getDescription() -> String {
    "Collection contains \(items.count) items"
}
```

Run the playground. You'll see that it still uses the implementation from `MovieCollection`, because that takes precedence over the default implementation.

Now, remove the implementation of `getDescription()` from `MovieCollection` and run the playground. The code still compiles, and `MovieCollection` still conforms to `MediaCollection`, because `getDescription()` is implemented in the protocol extension. This time, it prints the message from the default implementation.

Next, you'll see how to use generics to improve the code further. At the bottom of the playground, create a new type called `MediaShelf` that can represent any type of media:

```swift
struct MediaShelf: MediaCollection {

}
```

Then, add a generic type for the `items` to satisfy the protocol:

```swift
var items: [T] = []
```

Remember, this is all you need to conform to `MediaCollection`.

Finally, add the generic type to `MediaShelf`. By conforming it to `MediaItem`, you'll satisfy the compiler's requirements, enabling it to understand how to properly interface the protocol with the given type:

```swift
struct MediaShelf<T: MediaItem>: MediaCollection
```

Now, you can create some media items and shelves, then link them all together:

```swift
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
```

Run the playground. You'll see all the descriptions for the collections.

Finally, write an extension on `MediaShelf` to improve the description for video games:

```swift
extension MediaShelf where T == VideoGame {
    func getDescription() -> String {
        let xboxCount = items.filter({ $0.console == .xbox }).count
        let playstationCount = items.filter({ $0.console == .playstation }).count
        let switchCount = items.filter({ $0.console == .switch }).count
        return "This collection contains \(xboxCount) Xbox games, \(playstationCount) Playstation games and \(switchCount) Switch games"
    }
}
```

This extension is constrained to instances of `MediaShelf` where the items are exclusively video games. This is a really powerful feature to provide complex customization when using generics.

Run the playground. You'll see the new description for the video game shelf.

You can also restrict the generic type to a protocol:

```swift
extension MediaShelf where T: Codable {
    func printItems() throws {
        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(items)
        if let string = String(data: data, encoding: .utf8) {
            print(string)
        }
    }
}
```

This adds a new function to any `MediaShelf` where the items are `Codable`. Conform `BoardGame` to `Codable`:

```swift
struct BoardGame: MediaItem, Codable
```

And call the new function:

```swift
try boardGameShelf.printItems()
```

This prints the items on the shelf as a JSON string.

## Protocol Composition

The final feature you'll learn in this lesson is protocol composition. **Protocol composition** allows you to combine multiple protocols at either the point of conformance or at the point of usage.

Unlike inheritance, which limits you to subclassing a single type, protocols offer the flexibility to conform to multiple interfaces. This enables you to integrate various unrelated protocols into a single type, each serving a specialized function. You can then combine these narrowly focused protocols in a cohesive manner where it's beneficial.

To conform to multiple protocols, you add them as a comma-separated list. For example:

```swift
struct Movie: MediaItem, Codable, Sendable {
    // ...
}
```

This creates a `Movie` type that conforms to `MediaItem`, `Codable` and `Sendable`. Of course, you need to ensure you implement all the requirements for each protocol.

When defining a function that takes a type that conforms to multiple protocols, you can use `&` to combine them. For example:

```swift
func processItem(_ item: MediaItem & Codable) {
    
}
```

This function takes a type that must conform to `MediaItem` and `Codable`. If you try and pass it a type that doesn't conform to both, you'll get a compiler error.

## Demo

Head back to the playground in Xcode. First, define a new protocol called `RandomEntertainmentPicker` to help you pick what to do this evening:

```swift
protocol RandomEntertainmentPicker {
    associatedtype Item
    func getItemToEnjoy() -> Item?
}
```

This defines a protocol that returns a random item to enjoy. Then, conform `MediaShelf` to both `MediaCollection` and this protocol:

```swift
struct MediaShelf<T: MediaItem>: MediaCollection, RandomEntertainmentPicker {
    var items: [T] = []
    
    func getItemToEnjoy() -> T? {
        items.randomElement()
    }
}
```

This adds `RandomEntertainmentPicker` to the list of protocols that `MediaShelf` conforms to, then implements `getItemToEnjoy()` by returning a random item from the array.

Now, use the new protocol to find a video game to play:

```swift
print("Let's play \(videoGameShelf.getItemToEnjoy()?.title ?? "Nothing!")")
```

Run the playground and see what you'll be playing tonight!

Next, create a new function that uses protocol composition at the call site:

```swift
func printItemDetails(_ item: MediaItem & Codable) throws {
    let jsonEncoder = JSONEncoder()
    let data = try jsonEncoder.encode(item)
    if let string = String(data: data, encoding: .utf8) {
        print(string)
    }
}
```

This is very similar to the example with generics, except that it uses protocol composition to ensure you can only pass items to this function that match the requirements. Print out the details for Catan:

```swift
try printItemDetails(catan)
```

Run the playground. You'll see the JSON data for Catan. Try and pass a movie to the function; you'll get a compiler error:

```swift
try printItemDetails(noTimeToDie)
```

You get that compiler error because movies aren't `Codable`, so they don't satisfy the requirements for the function.

[Remove the line of code]

Finally, create a new type to represent a group of card games:

```swift
struct CardGames: RandomEntertainmentPicker {
    let games: [CardGame]
    
    func getItemToEnjoy() -> CardGame? {
        return games.randomElement()
    }
}
```

This defines a new type that conforms to `RandomEntertainmentPicker` and holds a `CardGame` collection, which was defined in the starter project. You can add some games and find something to play:

```swift
let bridge = CardGame(title: "Bridge")
let solitaire = CardGame(title: "Solitaire")

let cardGames = CardGames(games: [bridge, solitaire])
guard let cardGameToPlay = cardGames.getItemToEnjoy() else {
    fatalError("We have no card games!")
}
print("We have some cards so we'll play \(cardGameToPlay.title)")
```

Run the playground and discover which game you'll play tonight.

`CardGame`s don't conform to `MediaItem`. You can't store them on a `MediaShelf`, because that doesn't make sense. But it does make sense to be able to find a card game to play.

This shows how you can use protocols to define specific behaviors and use protocol composition to combine them when it makes sense.

## Conclusion

In this lesson, you've learned some advanced applications of protocols in Swift, gaining insights on how to construct APIs that are not only user-friendly but also offer compile-time safety. You explored the following key aspects: 

* How to use associated types to make your protocols generic.
* How to use protocol extensions to provide default implementations for functions — and how to add additional functions and properties, if required.
* How to use generics with protocols to make your code more flexible.
* How to use protocol composition to combine multiple protocols.
