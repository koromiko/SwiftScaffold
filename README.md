# SwiftScaffold

![](https://travis-ci.com/koromiko/SwiftScaffold.svg?branch=master)

SwiftScaffold is a architecture builder, which  helps you to create a well-structured project. SwiftScaffold now mainly focus on the MVVM-Coordinator pattern. 🏗️

If you're looking for an introduction to MVVM, [there](https://medium.com/flawless-app-stories/how-to-use-a-model-view-viewmodel-architecture-for-ios-46963c67be1b) you're. 

## Structure


### Cooridnator

The role of coordinator is to navigate the app, like transition, present, pop and so on. Every screen should have one coordinaor handling the navigation of it. 

### ViewModel
(TBD)

### View
(TBD)

### Controller
(TBD)



## Usage

### Coordinator

In this project, `Coordinator` is basically just a protocol. Object confirming this protocol is a domain specific coordinator in your project. Here, all you need to implement is the rootViewController:

```swift
class BaseCoordinator: Coordinator {
    var rootViewController: CoordinatorManagedViewController = AnyViewController()
}
```

The `CoordinatorManagedViewController` is a type alias, which is defined like this:

```swift
public typealias CoordinatorManagedViewController = UIViewController & CoordinatorManaged
```

That is, you need to implement your view controller to conform the `CoordinatorManaged`, so that it could be managed by the coordinator. The implemetation is easy, too: 

```swift
private class AnyViewController: CoordinatorManagedViewController {

    func open(from viewController: UIViewController) {
		// Define the presenting transition here
		viewController.present(self, animated: true, completion: nil)
    }

    func close() {
    	// Define the close transition here 
		self.dismiss(animated: true, completion: nil)
    }
}
```

Once the implementation is finished, we can use the coordinator like this: 

```swift 
// This represent current screen 
let mainCoordinator = BaseCoordinator() 

// Create another coordinator for the next screen
let detailCoordinator = DetailCoordinator() 

// This will present the root controller of detailCoordinator
mainCoordinator.present(coordinator: detailCoordinator)  
```

We are all set 🏗️.

With the help of this, you're able to write test for all navigation, and separate the responsibility of routing. 



## Requirements

## Installation

Currently, SwiftScaffold is **NOT** available through CocoaPods. Please stay tuned and I'll update one the project finished.


## Author

ShihTing Huang, koromiko1104@gmail.com

## License

SwiftScaffold is available under the MIT license. See the LICENSE file for more info.
