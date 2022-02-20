/// Raywenderlich - Arc and Memory Management in Swift

import UIKit

class MainViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    runScenario()
    
    }
  
  func runScenario() {
    let user = User(name: "Rafael")
    let iPhone = Phone(model: "iPhone 11")
    
    user.add(phone: iPhone)
    
    let subscription = CarrierSubscription(name: "TelBel",
                                           countryCode: "0032",
                                           number: "31415926",
                                           user: user)
    
    iPhone.provision(carrierSubscription: subscription)
    
    print(subscription.completePhoneNumber())
    
    let greetingMaker: () -> String

    do {
      let mermaid = WWDCGreeting(who: "caffeinated mermaid")
      greetingMaker = mermaid.greetingMaker
    }

    print(greetingMaker()) // TRAP!

    do {
      let ernie = Person(name: "Ernie")
      let bert = Person(name: "Bert")
      
      ernie.friends.append(Unowned(bert))
      bert.friends.append(Unowned(ernie))
      
      let firstFriend = bert.friends.first?.value // get ernie
      
      for friend in ernie.friends {
        print(friend)
      }
    }
  }
}


// MARK: - User Class

class User {
  let name: String
  var subscriptions: [CarrierSubscription] = []

  private(set) var phones: [Phone] = []

  func add(phone: Phone) {
    phones.append(phone)
    phone.owner = self
  }
  
  init(name: String) {
    self.name = name
    print("User \(name) was initialized")
  }

  deinit {
    print("Deallocating user named: \(name)")
  }
}


// MARK: - Phone Class

class Phone {
  let model: String
  weak var owner: User?
  
  var carrierSubscription: CarrierSubscription?

  init(model: String) {
    self.model = model
    print("Phone \(model) was initialized")
  }

  deinit {
    print("Deallocating phone named: \(model)")
  }
  
  func provision(carrierSubscription: CarrierSubscription) {
    self.carrierSubscription = carrierSubscription
  }

  func decommission() {
    carrierSubscription = nil
  }
}


// MARK: - CarrierSubscription Class

class CarrierSubscription {
  let name, countryCode, number: String
  unowned let user: User
  
  lazy var completePhoneNumber: () -> String = { [unowned self] in
    return "\(self.countryCode) \(self.number)"
  }
              
  init(name: String, countryCode: String, number: String, user: User) {
    self.name = name
    self.countryCode = countryCode
    self.number = number
    self.user = user
    user.subscriptions.append(self)

    print("CarrierSubscription \(name) is initialized")
  }

  deinit {
    print("Deallocating CarrierSubscription named: \(name)")
  }
}


// MARK: - WWDCGreeting Class

class WWDCGreeting {
  let who: String
  
  init(who: String) {
    self.who = who
  }

  lazy var greetingMaker: () -> String = { [weak self] in
    guard let self = self else {
      return "No greeting available."
    }
    return "Hello \(self.who)."
  }
}


// MARK: - Node Struct
/// Node was changed from Struct to Class because it uses self reference (var next: Node?)

class Node { // Error
  var payload = 0
  var next: Node?
}


// MARK: - Unowned Class

class Unowned<T: AnyObject> {
  unowned var value: T
  
  init (_ value: T) {
    self.value = value
  }
}


// MARK: - Person Class

class Person {
  var name: String
  var friends: [Unowned<Person>] = []
  
  init(name: String) {
    self.name = name
    print("New person instance: \(name)")
  }

  deinit {
    print("Person instance \(name) is being deallocated")
  }
}






/// An Object’s Lifetime:
/// - The lifetime of a Swift object consists of five stages:////Allocation: Takes memory from a stack or heap.
/// - Initialization: init code runs.
/// - Usage.
/// - Deinitialization: deinit code runs.
/// - Deallocation: Returns memory to a stack or heap.




// Capture Lists Sample

//var x = 5
//var y = 5
//
//let someClosure = { [x] in
//  print("\(x), \(y)")
//}
//x = 6
//y = 6
//
//someClosure()        // Prints 5, 6
//print("\(x), \(y)")  // Prints 6, 6
