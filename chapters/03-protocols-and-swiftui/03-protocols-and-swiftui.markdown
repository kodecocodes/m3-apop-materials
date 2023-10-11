```metadata
number: "4"
title: "Lesson 3: Protocols and SwiftUI"
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
  In this lesson, you'll learn how to apply your knowledge of protocols to build views in SwiftUI.
```

# Lesson 3: Protocols and SwiftUI

## Introduction

In the previous two lessons, you learned how protocols work, how to define them and how to use them. You learned the differences between protocols and inheritance and how to utilize some of the advanced features of protocols to improve your code. In this lesson, you'll learn how to take your new-found knowledge and apply it to building SwiftUI views.

## SwiftUI

SwiftUI is Apple's new declarative UI framework for building apps across all of their platforms. Unlike UIKit and AppKit, which are based on Objective-C, SwiftUI is built for Swift using modern programming paradigms. One of these is moving away from inheritance and using protocols to build your views instead.

In Objective-C, all views are subclassed from `UIView`, which in turn is a subclass of `NSObject` — the base class for all objects in Objective-C. This meant your view inherited all the behavior from `UIView` automatically. With SwiftUI, this is no longer the case.

### SwiftUI Views

In SwiftUI, all views conform to the `View` protocol. `View` represents a part of your user interface. It requires a single property: `body`, which returns another `View`. This allows you to create lightweight views that you can build on top of each other.

And because it's a protocol, you can conform any type to a `View` using an extension — even types you don't own. SwiftUI contains a number of views you can use to create your own views, such as `List`, `Text`, `Image` and `Button`. For example, if you wanted to create a view for a `Person`, you could write:

```swift
HStack {
    Text(person.name)
    Text(person.age)
}
```

This uses an `HStack` to lay out two `Text` views, one on top of the other.

`Views` have a number of modifiers available to them. Thanks to protocol extensions, they even have accessibility features built right in. 

> **Note**: For more information on SwiftUI itself, check out the awesome [SwiftUI By Tutorials book](https://www.kodeco.com/books/swiftui-by-tutorials/v4.0) and the many incredible SwiftUI articles on Kodeco.

## Demo

In this demo, you'll take your knowledge from the previous lessons and build some views using protocols. Open the starter playground in Xcode and run it. A simple view will appear.

The starter project contains many of the types from the previous lesson, allowing you to expand your Media project by building some views with it. The playground also has some code at the bottom to make it possible to display a `View`; currently, this just displays some text.

First, start by re-implementing the generic `MediaCollection` as a view called `MediaCollectionView`, then make it conform to `View`:

```swift
struct MediaCollectionView<T: MediaItem>: MediaCollection & View {
    var items: [T]
}
```

This looks similar to the previous lesson, but with the added feature of conforming to `View` through protocol composition. `View` requires a `body` property. Implement that next:

```swift
var body: some View {

}
```

To start, you'll keep it simple and return a `Text` view:

```swift
Text("Hello SwiftUI")
```

Finally, change `PlaygroundPage` to return your new view:

```swift
let view = MediaCollectionView(items: [arkhamKnight, tearsOfTheKingdom])
PlaygroundPage.current.setLiveView(view.frame(width: 375, height: 667))
```

Run the playground. You'll see your new text displayed.

Your next goal is to change the view to show some information from your media items. Change the generic type in `MediaCollectionView` to also be `Identifiable`.

```swift
struct MediaCollectionView<T: MediaItem & Identifiable>: MediaCollection & View
```

`Identifiable` is another protocol. It declares that the items it's applied to must have a unique identifier to distinguish them from each other. The starter project already ensures that each `MediaItem` conforms to this and has an `id` property.

Now that you are able to distinguish all the items in `items`, you can use a list to display each item:

```swift
var body: some View {
    List(items) {
        Text($0.title)
    }
}
```

This now displays a list with more information from your media shelf! But you can make this even better.

Write an extension to make `MediaItem` conform to `View` itself:

```swift
extension MediaItem {
    var body: some View {
        Text(self.title)
    }
}
```

Now, make the generic type of `MediaCollectionView` conform to `View` as well:

```swift
struct MediaCollectionView<T: MediaItem & Identifiable & View>: MediaCollection & View 
```

Then, change the `view` implementation to return the new `View` directly:

```swift
var body: some View {
    List(items) {
        $0
    }
}
```

Finally, extend `VideoGame` to conform to `View` as well:

```swift
extension VideoGame: View {}
```

Since `MediaItem` already conforms to `View`, you don't have to do anything else!

Run the playground. You'll see the same list as before, but this time it's using `MediaItem` directly as a `View`!

## Protocol-Oriented Programming

**Protocol-Oriented Programming** is a design pattern that enables you to abstract implementation details across various components of your app. It's commonly used to separate concerns in your code, such as decoupling UI logic from data logic.

For example, you might have a `View` to display a list of books. The view shouldn't care about how the items are retrieved or whether it needs to make specific API calls or database queries to get the data. Instead, you can define a protocol:

```swift
protocol BookRepository {
    func getBooks() async throws  -> [Book]
    func createBook(_ book: Book) async throws
}
```

This protocol outlines a few functions for retrieving and creating books Note how there are no implementation details; that's decided by the implementer of the protocol. The view simply uses the protocol's API to perform the actions it needs to.

This also makes it very easy to change the implementation; for example, you can easily switch between using SwiftData and an API or even some mocked data for testing.

You could then provide an implementation of this protocol that uses an API:

```swift
// 1
struct APIBookRepository: BookRepository {
    // Define URLs...

    // 2
    func getBooks() async throws -> [Book] {
        // 3
        let (data, _) = try await URLSession.shared.data(from: booksURL)
        return try JSONDecoder().decode([Book].self, from: data)
    }
    
    // 4
    func createBook(_ book: Book) async throws {
        // 5
        let data = try JSONEncoder().encode(book)
        // 6
        var request = URLRequest(url: createBookURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        // 7
        _ = try await URLSession.shared.data(for: request)
    }
}
```

Here's what the code does:

1. Defines a new type that conforms to `BookRepository` to retrieve books from an API.
2. Implements `getBooks()` to retrieve books from the API.
3. Uses `URLSession` to retrieve the data from the API and decode the response to an array of `Book`s. The function must return this information.
4. Implements `createBook(_:)` to create a new book.
5. Encodes the book to JSON.
6. Creates a `URLRequest` to send to the API. Sets the method, header and body parameters for sending the new book data to the API.
7. Sends the request to the API using `URLSession`.

> **Note**: For most SwiftUI apps, the responsibility of retrieving data is usually handled by a `ViewModel` rather than the `View` directly. The `View`'s sole responsibility is to display the data it receives. For more information, check out [Advanced iOS App Architecture](https://www.kodeco.com/books/advanced-ios-app-architecture/v4.0) and other related Kodeco articles on the Model-View-ViewModel (MVVM) pattern.

## POP Demo

Head back to Xcode, where you'll see how to use POP for the media shelf.

First, define a new protocol for the repository: 

```swift
protocol MediaRepository {
    associatedtype Item: MediaItem & Identifiable & View
    
    func getItems() async throws -> [Item]
}
```

The protocol has a single function to retrieve the items. Just like the `MediaCollection`, the protocol uses generics with constrained types so it works for all `MediaItems`.

Next, create an implementation for the repository that returns some hard-coded video games:

```swift
struct VideoGameMediaRepository: MediaRepository {
    func getItems() async throws -> [VideoGame] {
        [arkhamKnight, tearsOfTheKingdom].shuffled()
    }
}
```

The `VideoGameMediaRepository` implements the required `getItems()` and simply returns two hard-coded games. This approach is particularly useful in unit tests, eliminating the need for a database or an external API. `VideoGamesMediaRepository` uses `shuffled()` to make the order of the array random each time.

Next, update the `items` property from `MediaCollectionView` and add the repository:

```swift
let repository: any MediaRepository
@State var items: [T] = []
```

This adds a new property for the repository and makes the `items` array initially empty, since the data will now come from the repository. `items` is also annotated with `@State`, so the view updates when the array changes.

Next, update the live view to use the new repository. This will remove the errors:

```swift
let view = MediaCollectionView<VideoGame>(repository: VideoGameMediaRepository())
```

Rather than accepting an array of items for display, this now takes the repository as an argument, which serves as the source for the items.

Then, add a task to run when the SwiftUI view is created:

```swift
.task {
    self.items = try! await repository.getItems() as! [T]
}
```

The task gets the items from the repository. You're using a force `try` here for simplicity's sake, but in your apps you should handle this correctly and display an appropriate error if it fails.

You're also force casting the returned items. This is because the compiler can't infer that the generic items from the repository match the generic requirements on the `View`. Since you know they're the same here, this is safe to do.

Finally, add a **pull to refresh** action to the list, so you can reload the items when you want:

```swift
.refreshable {
    self.items = try! await repository.getItems() as! [T]
}
```

This retrieves data from the repository, similar to the initial task that loads the view.

Run the playground. You'll see the list in the view. Pull to refresh several times, and you'll see the order change! Remember, the repository shuffles the order of items returned.

When creating your view, you could use any implementation of `MediaRepository` you want. For example, you could create a repository that retrieves the items from a database or an API. The code for the view wouldn't have to change, because all the calls go through the protocol.

## Conclusion

After completing this lesson, you now know how to apply your knowledge of protocols to SwiftUI to make flexible, powerful views.

Specifically, you learned:

* How to create a view using protocols to make the view reusable.
* How to conform to protocols to make your types conform to SwiftUI's `View` protocol.
* How to use POP to make it easy to switch out different parts of your code.
* How to provide an implementation for protocols to use in your views.
