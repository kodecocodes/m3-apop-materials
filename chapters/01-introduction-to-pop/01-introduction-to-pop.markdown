```metadata
number: "4"
title: "Lesson 1: Protocols Continued"
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
  In this lesson, you'll learn what protocols/interfaces are, how to use them and how they compare to object-oriented programming. You'll also learn what Protocol-Orientated Programming is and how to use it to write better code.
```

# Lesson 1: Introduction to Protocol-Oriented Programming

## Introduction

Protocols in Swift are similar to interfaces in Kotlin and some other languages. Although both protocols and interfaces relate to the concept of inheritance, they differ in key ways. Protocols offer a powerful way to structure your apps, abstract away from external dependencies and simplify both testing and code organization.

In this module, you'll learn the fundamentals of protocols and how to use them in your apps. You'll see how to define them, how to implement them and how they provide a similar role to inheritance at a very high level. You'll also learn about the differences that separate the two concepts.

Along the way, you'll learn how to use some of the features of protocols in Swift, like composition, to build complex types that aren't possible with inheritance. Finally, you'll have the opportunity to use protocols in a SwiftUI app.

**Protocol-Oriented Programming**, or POP, takes the protocol concept and applies it to a design pattern for your software. POP makes it easy to integrate third-party dependencies, write testable code and build apps that are easy to maintain.

## Protocols/Interfaces

As you learned in a previous lesson, protocols create a blueprint for defining how a type should look from an API perspective. In a protocol, you define the properties and methods that a type should have. Any type that conforms to that protocol **must** implement those properties and methods. This enables you to interact with a protocol without requiring knowledge of the actual type.

### Defining a Protocol

You define a protocol in Swift with the `protocol` keyword. For example, this code defines a protocol for a vehicle:

```swift
// 1
protocol Vehicle {
  // 2
  var numberOfWheels: Int { get }
  // 3
  var maxSpeed: Double { get }
  // 4
  var totalDistanceTraveled: Double { get set }
  // 5
  func showDetails() -> String
  // 6
  func move(direction: Direction, duration: TimeInterval, speed: Double)
}
```

Here's a breakdown of the code snippet:

1. Defines a protocol called `Vehicle` that types can conform to. Any type that adopts this protocol must provide implementations for the properties and functions defined within it. 
2. Defines a property on the protocol called `numberOfWheels`. The property is of type `Int`, which means it should represent the number of wheels the vehicle has. By including this requirement in the protocol, any type conforming to `Vehicle` must provide an implementation of this property.
3. Defines a property called `maxSpeed` that is a `Double`. This property indicates the maximum speed the vehicle can achieve.
4. Defines a property on the protocol called `totalDistanceTraveled` that is a `Double`. Note that this property is read-write because it specifies both `get` and `set`. `numberOfWheels` and `maxSpeed` are read-only because they only specify the `get` keyword on the property. This means that you can **mutate** (that is, change) `totalDistanceTraveled`. Since `numberOfWheels` and `maxSpeed` are read-only — also known as **immutable** — you cannot change them once you've set their initial value. This allows you to ensure properties that *shouldn't* change can never *be* changed.
5. Defines a function on the protocol, `showDetails()`, that returns a `String` that provides details about the vehicle when executed.
6. Defines a function, `move(direction:duration:speed:)`, that takes `Direction`, `TimeInterval` and `Double` as parameters. `Direction`, in this case, could be a simple enum describing the direction of travel.

Now, when you refer to a `Vehicle` in your code, you know it has these properties and functions available for you to use. The protocol doesn't define whether the properties need to be **computed** properties or **stored** properties. That's up to the type that conforms to the protocol.

### Conforming to a Protocol

You define a type that implements the protocol as follows:

```swift
// 1
class FamilyCar: Vehicle {

  // 2
  let maxSpeed: Double
  let numberOfWheels: Int
  var totalDistanceTraveled: Double
  
  // 3
  init() {
    self.maxSpeed = 50.0
    self.numberOfWheels = 4
    self.totalDistanceTraveled = 0.0
  }
  
  // 4
  func move(direction: Direction, duration: TimeInterval, speed: Double) {

  }
  
  // 5
  func showDetails() -> String {
    "I am a family car"
  }
}
```

The code demonstrates how to define a type that adheres to the `Vehicle` protocol. Now, you'll break down the different components of this process:

1. Defines a new class called `FamilyCar` that conforms to the `Vehicle` protocol. Conforming to a protocol looks similar to subclassing a type. In essence, `FamilyCar` will adopt the behavior and requirements that `Vehicle` specifies. 
2. Define each property as required by the protocol. They need to be implemented according to the protocol's specifications. 
3. Initialize the properties of the class. The `init()` method is the initializer of the `FamilyCar` class. 
4. Implement `move(direction:duration:speed:)` as the protocol requires. This implements the function required by the protocol; it will handle moving the car in your program. In this case, you'll track the distance traveled by the `FamilyCar`.
5. Implement `showDetails()` as the protocol requires with a simple implementation. This function just returns a sensible description for the type to make it easy to distinguish between different types of `Vehicle`s.

You've now created a class called `FamilyCar` and defined it to conform to the `Vehicle` protocol. By adhering to the protocol, the class must provide implementations for all the properties and functions specified by the protocol. This adherence allows you to create instances of `FamilyCar` that share a common interface with other types conforming to the same protocol, enabling seamless interactions and code reusability.

## Implementing With Inheritance

Now, compare how you'd implement this using inheritance. To start, you'd define a superclass that matches the protocol:

```swift
// 1
open class VehicleType {
  // 2
  let numberOfWheels: Int
  // 3
  var maxSpeed: Double
  var totalDistanceTraveled: Double

  // 4
  init() {
    self.numberOfWheels = 4
    self.maxSpeed = 100
    self.totalDistanceTraveled = 0.0
  }

  // 5
  func move(direction: Direction, duration: TimeInterval, speed: Double) {
    
  }

  // 6
  func showDetails() -> String {
    "I am a vehicle"
  }
}
```

Here's what the superclass does:

1. Defines a new class called `VehicleType` that's open so it can be subclassed.
2. Defines the properties; these match the properties in the protocol.
3. Note that `maxSpeed` must be a variable if you want to override it in a subclass. This may not be desirable if, semantically, you want a read-only property.
4. Implement an initializer.
5. Defines `move(direction:duration:speed:)`, which matches the function in the protocol.
6. Defines `showDetails()`, which also matches the function in the protocol.

Now, implement a new family car using inheritance:

```swift
// 1
class FamilyCarInheritance: VehicleType {
  // 2
  let carMaxSpeed = 50.0
  // 3
  override var maxSpeed: Double {
    get {
      return carMaxSpeed
    }
    set {
      // Do nothing
    }
  }

  // 4
  override func move(direction: Direction, duration: TimeInterval, speed: Double) {
    super.move(direction: direction, duration: duration, speed: speed)
    print("Current distance is \(totalDistanceTraveled)")
  }

  // 5
  override func showDetails() -> String {
    "I am a family car"
  }
}
```

This does the following:

1. Defines a new class, `FamilyCarInheritance`, that inherits from `VehicleType`.
2. Defines an immutable property, `carMaxSpeed`, to hold the maximum speed of the car. This ensures it can't be mutated.
3. Overrides the `maxSpeed` property to return the `carMaxSpeed` property. This allows you to set a different maximum speed than the superclass.
4. Overrides `move(direction:duration:speed:)` to call the superclass implementation, then print the current distance traveled.
5. Overrides `showDetails()` to return the correct description for the car.

## Demo

To really compare the differences between protocols and inheritance, it's time to write some code! In this demo, you'll implement the code for `FamilyCar` and see how to use the types in a simple app. You'll then build the same functionality into a type using inheritance to compare the two different approaches. 

First, open the starter playground from this lesson's materials. Inside `FamilyCar`, implement `move()`:

```swift
// 1
let travelingSpeed: Double
if speed < 0 {
  travelingSpeed = 0
} else if speed > maxSpeed {
  travelingSpeed = maxSpeed
} else {
  travelingSpeed = speed
}
// 2
let distance = travelingSpeed * duration
// 3
if direction == .backwards {
  totalDistanceTraveled = totalDistanceTraveled - distance
  print("Traveled -\(distance)")
} else {
  totalDistanceTraveled = totalDistanceTraveled + distance
  print("Traveled \(distance)")
}
```

This does the following:

1. Works out the speed the car is traveling, ensuring it's not less than 0 or greater than the maximum speed.
2. Calculates the distance traveled by multiplying the speed by the duration.
3. Adds the distance traveled to the total distance traveled — or subtracts it, if the car is traveling backwards.

Now that you've implemented `move()`'s functionality, you can see how to use the function. First, create an instance of `FamilyCar` to call the function on.

```swift
let familyCar = FamilyCar()
```

Then, call `move()` on the `FamilyCar` a couple of times and print the details to run through the implementation and see how to call the functions on your type:

```swift
familyCar.move(direction: .forward, duration: 15, speed: 30)
familyCar.move(direction: .forward, duration: 15, speed: 60)
print(familyCar.showDetails())
```

Run the playground; you'll see the message appear in the console.

Next, implement `move()` in `VehicleType`. You can copy and paste the code from `FamilyCar`:

```swift
let travelingSpeed: Double
if speed < 0 {
  travelingSpeed = 0
} else if speed > maxSpeed {
  travelingSpeed = maxSpeed
} else {
  travelingSpeed = speed
}
// 2
let distance = travelingSpeed * duration
// 3
if direction == .backwards {
  totalDistanceTraveled = totalDistanceTraveled - distance
  print("Traveled -\(distance)")
} else {
  totalDistanceTraveled = totalDistanceTraveled + distance
  print("Traveled \(distance)")
}
```

You've now implemented the function for the inheritance option. Note that you're implementing the code in the superclass; therefore, you don't need to implement it in the subclass.

Next, create an instance of `FamilyCarInheritance` and call the same functions as the protocol implementation to see how to use it:

```swift  
let familyCar2 = FamilyCarInheritance()
familyCar2.move(direction: .forward, duration: 15, speed: 30)
familyCar2.move(direction: .forward, duration: 15, speed: 60)
print(familyCar2.showDetails())
```

This has the same output as the protocol implementation. Up to this point, there's no real difference.

One of the advantages of using protocols in Swift is you can leverage the compiler to check your code for you. At the bottom of the playground, create a new vehicle that conforms to the protocol:

```swift
class Truck: Vehicle {
    
}
```

See how you already get an error from the compiler because the type is missing the properties and functions that the protocol requires. Use Xcode's Fix-It shortcut to add the stubs for you.

Next, implement `showDetails()`:

```swift
"I am a truck"
```

Then, implement `move(direction:duration:speed:)`. Again, you can copy and paste the code from `FamilyCar`:

```swift
let travelingSpeed: Double
if speed < 0 {
  travelingSpeed = 0
} else if speed > maxSpeed {
  travelingSpeed = maxSpeed
} else {
  travelingSpeed = speed
}
let distance = travelingSpeed * duration
if direction == .backwards {
  totalDistanceTraveled = totalDistanceTraveled - distance
  print("Traveled -\(distance)")
} else {
  totalDistanceTraveled = totalDistanceTraveled + distance
  print("Traveled \(distance)")
}
```

Finally, create an initializer:

```swift
init() {
  self.numberOfWheels = 6
  self.maxSpeed = 30
  self.totalDistanceTraveled = 0
}
```

The protocol defines `numberOfWheels` and `maxSpeed` as immutable, but you can still mutate them inside your type... which might make sense for your implementation. From the API perspective, it's read-only.

To demonstrate this, create a `Truck` and set the number of wheels to 12:

```swift
let truck = Truck()
truck.numberOfWheels = 12
```

There's nothing wrong with this code, and it compiles just fine. If you set the type of `truck` to be `Vehicle`, it _will_ fail to compile because the API does not match what the protocol defines:

```swift
let truck: Vehicle = Truck()
truck.numberOfWheels = 12
```

Remove the `type` annotation so your playground compiles again.

```swift
let truck = Truck()
truck.numberOfWheels = 12
```

Finally, change `totalDistanceTraveled` to a `let` in `Truck`:

```swift
let totalDistanceTraveled: Double
```

This time, you **do** get an error because the protocol defines the API of `Vehicle` to have a mutable property called `totalDistanceTraveled`. This doesn't exist in your new `Truck` implementation. Change your code back so it compiles.


## Comparing Protocols to Inheritance

If you really squint, the two approaches are fairly similar. They both allow you to define a blueprint for your types, such as properties and functions. However, the similarities end there. Protocols define the API for types to make it possible to interact with them without caring about the type. Inheritance defines the behavior of types as well as the API.

With inheritance, it's possible to create an instance of the superclass that doesn't make any sense. For example, you could write:

```swift
let vehicle = VehicleType()
vehicle.move(direction: .forward, duration: 15, speed: 30)
print(vehicle.showDetails())
```

In this example, you create an instance of `VehicleType`. But what does that mean? It doesn't make sense to have a generic vehicle you can instantiate and pass around as a concrete type. Protocols make much more sense in this case.

On the other hand, with protocols, every implementor has to implement all the variables and all the functions, even if they're the same. This can lead to duplicated code. There are a couple of other disadvantages to superclasses:

* You can only inherit from one superclass. If you want to inherit behavior from two unrelated superclasses — you can't. It isn't possible. With protocols, you can conform to as many as you like.
* You have no control over how your superclasses behave. They may change the values of properties that you rely on or perform additional logic that conflicts with your own. Remember, protocols only define the API of the types — the implementation is entirely up to you.

These disadvantages are why Swift favors protocols over inheritance (such as in SwiftUI).

Protocols are very useful for testing your code in this sense. You can define a protocol to retrieve your users from an API. In your tests, you can use a different implementation that returns hardcoded users. With inheritance, you'd need to be careful to ensure that your test subclass doesn't make network requests, for instance.

> **Note**: In Kotlin, you can create abstract classes. These classes cannot be instantiated; you can only use them by subclassing them. In Swift, you can use protocol extensions to provide a default implementation for a function. You'll see this in a later lesson.

## Protocol-Orientated Programming

Now that you understand the basics of protocols, you can start to learn about how to use them in your code. Protocol-Orientated Programming is a technique where you move different parts of your code to be called via a protocol. This could be a third-party dependency, a database, an API or even different modules for your app. 

Using protocols to call different areas of your code provides a number of benefits:

1. **Writing tests for your code** is easier. If you're interacting with a database or API, you can call them via a protocol. This lets you use a different implementation of that protocol — that you can control — when running your tests. For example, when calling a third-party API, using a protocol makes it easy to test for different responses and errors.
2. **Changing third-party dependencies** is easier. Imagine you're writing a weather app and are using a library to get the weather details for different locations, rainfall information, wind speed and so on. If the library you're using stops working, or you don't want to use it anymore, it can be difficult to change it if the library is deeply coupled throughout your codebase. If all the calls to the library are made via a protocol you wrote, then you can pick a new library, write an implementation for your protocol for that library and use it without having to change any other code. 
3. **Splitting up your app** is easier. When your app becomes large or complex, you'll want to break it up into different modules. If you define the interactions with those modules via protocols, you can break the work up into different teams and still know how to use the different modules. You can use simple, hard-coded implementations of the protocol until the real module is ready.

You'll learn more about POP and how to use it in Lesson 3.

## Conclusion

In this lesson, you learned some of the basics of protocols and how to use them, such as defining common interfaces and specifying the interactions between different parts of your code. Protocols are a tool in your coding backpack that's similar to inheritance, but each one has different use cases. You should be sure to use the right tool for the job, depending on your circumstances.

In this lesson, you learned:

* How to define a protocol in Swift with mutable and immutable properties and functions.
* How to create and use a type that conforms to a protocol.
* How protocols compare to inheritance, where they differ and why you might prefer protocols over inheritance in some scenarios.
* How the compiler can help ensure the types that implement your protocols are correct.

## Quiz

1. Types can inherit from multiple superclasses? True or False [False]
2. Types can inherit from multiple protocols? True or False [True]
3. You don't need to implement all the properties and functions of a protocol? True or False [False]
4. Read-only properties in a protocol can be mutable in a type that conforms to it? True or False [True]
