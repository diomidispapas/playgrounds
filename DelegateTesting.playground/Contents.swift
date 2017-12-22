// Example of delegate testing
// The playground doesn't run, copy the following in an Xcode project

import Foundation
import XCTest

protocol Delegate: class {
    func classWithDelegate(_ :ClassWithDelegate, didCompleteAsyncStuffWithResult result: Bool)
}

final class ClassWithDelegate {
    
    weak var delegate: Delegate?
    
    func asyncTask() {
        self.delegate?.classWithDelegate(self, didCompleteAsyncStuffWithResult: true)
    }
}

final class ClassWithDelegateTests: XCTestCase {
    
    func testClassWithDelegate_receivesDelegateCallbacks_whenStateChanges() {
        let classWithDelegate = ClassWithDelegate()
        let mockDelegate = MockDelegate()
        let delegateExpecation = expectation(description: #function)
        mockDelegate.callback = { [weak delegateExpecation] result in
            delegateExpecation?.fulfill()
        }
        classWithDelegate.delegate = mockDelegate
        classWithDelegate.asyncTask()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

final class MockDelegate: Delegate {
    
    var callback: ((Bool) -> Void)?

    // MARK: Delegate
    func classWithDelegate(_ :ClassWithDelegate, didCompleteAsyncStuffWithResult result: Bool) {
        callback?(true)
    }
}

