/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class MainViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    runScenario()
  }

  func runScenario() {
    let user = User(name: "John")
    let phone = Phone(model: "iPhone Xs")

    user.add(phone: phone)

    let subscription = CarrierSubscription(name: "TelBel", countryCode: "0032", number: "3145678", user: user)
    phone.provision(carrierSubscription: subscription)

    print(subscription.completePhoneNumber())

    let greetingMaker: () -> String

    do {
      let mermaid = WWDCGreeting(who: "caffeinated mermain")
      greetingMaker = mermaid.greetingMaker
    }

    print(greetingMaker())

    let ernie = Person(name: "Ernie")
    let bert = Person(name: "Bert")

    ernie.friends.append(Unowned(bert))
    bert.friends.append(Unowned(ernie))
  }
}

class User {
  let name: String
  var subscriptions: [CarrierSubscription] = []

  private (set) var phones: [Phone] = []

  init(name: String) {
    self.name = name
    print("User \(name) was initialized")
  }

  deinit {
    print("Deallocating user named: \(name)")
  }

  func add(phone: Phone) {
    phones.append(phone)
    phone.owner = self
  }
}

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

class CarrierSubscription {
  let name: String
  let countryCode: String
  let number: String
  unowned let user: User

  lazy var completePhoneNumber: () -> String = { [unowned self] in
    self.countryCode + " " + self.number
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

class WWDCGreeting {
  let who: String

  init(who: String) {
    self.who = who
  }

  lazy var greetingMaker: () -> String = { [weak self] in
    guard let self = self else {
      return "No greeting available"
    }

    return "Hello, \(self.who)"
  }
}

class Node {
  var payload = 0
  var next: Node?
}

class Person {
  var name: String
  var friends: [Unowned<Person>] = []
  init(name: String) {
    self.name = name
    print("New person instance: \(name)")
  }

  deinit {
    print("Deallocating Person named: \(name)")
  }
}

class Unowned<T: AnyObject> {
  unowned var value: T
  init(_ value: T) {
    self.value = value
  }
}
