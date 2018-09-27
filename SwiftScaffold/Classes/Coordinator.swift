//
//  Coordinator.swift
//  SwiftScaffold
//
//  Created by S.T Huang on 2018/09/27.
//  Copyright © 2018 S.T Huang. All rights reserved.
//

import UIKit
public typealias CoordinatorManagedViewController = UIViewController & CoordinatorManaged

private struct AssociatedKey {
    static var childCoordinatorKey: String = "AssociatedKey.childCoordinator.key"
    static var parentCoordinatorKey: String = "AssociatedKey.parentCoordinator.key"
    static var managedViewControllerKey: String = "AssociatedKey.managedViewController.key"
    static var coordinatorKey: String = "AssociatedKey.coordinator.key"
}

/**
 The coordinator's protocol
 Conform this protocol by providing the rootViewController and the coordinator then could be presented by extension func present(:) and pop()
 */
public protocol Coordinator: AnyObject {
    /// Implement this var to assign the root view controller of the module
    var rootViewController: CoordinatorManagedViewController { get set }

    /// The parent coordinator presenting this coordinatir
    var parentCoordinator: Coordinator? { get }

    /// The child coordinator presented by this coordinator
    var childCoordinator: Coordinator? { get }

    /// The view controllers that are maanged by this coordinator
    var managedViewControllers: [CoordinatorManagedViewController] { get }

    /// Presnet a module owned by the given coordinator
    func present(coordinator: Coordinator)

    /// Presnet a view controller
    func present(viewController: CoordinatorManagedViewController)

    /// Dismiss self from current screen
    func dismiss()

    /// Pop the last view controller in the view controller stack
    func dismissLastViewController()

}

public protocol ViewControllerCoordinator: Coordinator {
    /// The view controllers that are maanged by this coordinator
    var managedViewControllers: [CoordinatorManagedViewController] { get }
    /// Presnet a view controller
    func present(viewController: CoordinatorManagedViewController)
    /// Pop the last view controller in the view controller stack
    func dismissLastViewController()
}

public extension Coordinator {
    var parentCoordinator: Coordinator? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.parentCoordinatorKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.parentCoordinatorKey) as? Coordinator
        }
    }

    var childCoordinator: Coordinator? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.childCoordinatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.childCoordinatorKey) as? Coordinator
        }
    }

    var managedViewControllers: [CoordinatorManagedViewController] {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.managedViewControllerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            var obj = objc_getAssociatedObject(self, &AssociatedKey.managedViewControllerKey) as? [CoordinatorManagedViewController]
            if obj == nil {
                objc_setAssociatedObject(self, &AssociatedKey.managedViewControllerKey, [rootViewController], .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                obj = [rootViewController]
            }
            return obj!
        }
    }

    func present(coordinator: Coordinator) {
        if let viewController = self.managedViewControllers.last {
            coordinator.rootViewController.open(from: viewController)
            coordinator.rootViewController.coordinator = coordinator
            childCoordinator = coordinator
            coordinator.parentCoordinator = self
        }
    }

    func dismiss() {
        if let viewController = self.managedViewControllers.last {
            viewController.close()
        }
        parentCoordinator?.childCoordinator = nil
    }

    func present(viewController: CoordinatorManagedViewController) {
        if let parentViewController = managedViewControllers.last {
            viewController.open(from: parentViewController)
            viewController.coordinator = self
            managedViewControllers.append(viewController)
        }
    }

    func dismissLastViewController() {
        if managedViewControllers.count > 0 {
            let lastViewController = managedViewControllers.removeLast()
            lastViewController.close()
        }
    }
}

public protocol CoordinatorManaged: AnyObject {
    /// Handful property the coordinator
    var coordinator: Coordinator? { get set }

    /// Implement the way to present this view controller
    func open(from viewController: UIViewController)

    /// Implement the way to close this view controller
    func close()
}

public extension CoordinatorManaged {
    weak var coordinator: Coordinator? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.coordinatorKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.coordinatorKey) as? Coordinator
        }
    }
}
