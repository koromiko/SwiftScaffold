//
//  CoordinatorTests.swift
//  SwiftScaffoldTest
//
//  Created by S.T Huang on 2018/09/19.
//  Copyright © 2018 S.T Huang. All rights reserved.
//

import XCTest
@testable import SwiftScaffold

class CoordinatorTests: XCTestCase {

    var sut: Coordinator?
    private var mainViewController: MockViewController?

    override func setUp() {
        sut = BaseCoordinator()
        mainViewController = sut?.rootViewController as? MockViewController
    }

    override func tearDown() {
        mainViewController = nil
        sut = nil
    }


    // MARK: Push/Pop Coordinator
    func testPresentRetainThePresentedCoordinator() {
        let presentedCoordinator = MockCoordinator()
        sut?.present(coordinator: presentedCoordinator)
        let same = (sut?.childCoordinator === presentedCoordinator)
        XCTAssertTrue(same)
    }

    func testPresentCoordinatorWillPresentViewControllerFromTheLastManagedViewController() {
        let presentedCoordinator = MockCoordinator()

        sut?.present(coordinator: presentedCoordinator)
        XCTAssertEqual(sut?.managedViewControllers.last, (presentedCoordinator.rootViewController as? MockViewController)?.fromViewController)
    }

    func testPopRemoveReferenceOfSelf() {
        let presentedCoordinator = MockCoordinator()
        sut?.present(coordinator: presentedCoordinator)
        XCTAssertNotNil(sut?.childCoordinator)

        presentedCoordinator.dismiss()
        XCTAssertNil(sut?.childCoordinator)

    }

    func testPopDoCloseTheViewController() {
        let presentedCoordinator = MockCoordinator()
        let presentedViewController = presentedCoordinator.rootViewController as! MockViewController
        sut?.present(coordinator: presentedCoordinator)

        precondition(sut?.childCoordinator != nil)
        presentedCoordinator.dismiss()
        XCTAssertTrue(presentedViewController.isCloseCalled)
    }


    // MARK: Push/Pop viewController
    func testPushPopViewController() {
        let viewController = MockViewController()
        let viewController2 = MockViewController()
        let viewController3 = MockViewController()
        sut?.present(viewController: viewController)
        sut?.present(viewController: viewController2)
        sut?.present(viewController: viewController3)
        XCTAssertEqual(viewController.fromViewController, sut?.rootViewController)
        XCTAssertEqual(viewController2.fromViewController, viewController)
        XCTAssertEqual(viewController3.fromViewController, viewController2)

        sut?.dismissLastViewController()
        XCTAssertTrue(viewController3.isCloseCalled)
        XCTAssertFalse(viewController2.isCloseCalled)
        XCTAssertFalse(viewController.isCloseCalled)
    }

}

private class BaseCoordinator: Coordinator {
    var rootViewController: CoordinatorManagedViewController = MockViewController()
}

private class MockCoordinator: Coordinator {
    var rootViewController: CoordinatorManagedViewController = MockViewController()
}

private class MockViewController: CoordinatorManagedViewController {

    var fromViewController: UIViewController?
    var isCloseCalled: Bool = false

    func open(from viewController: UIViewController) {
        fromViewController = viewController
        viewController.present(self, animated: true, completion: nil)
    }

    func close() {
        isCloseCalled = true
        self.dismiss(animated: true, completion: nil)
    }
}
