// Copyright (c) David Bagwell - https://github.com/dbagwell
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Rebar
import UIKit

public protocol NavigationController: AnyObject {
    
    var viewControllers: [UIViewController] { get set }
    func push(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func pop(to viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    
}

extension NavigationController {
    
    // MARK: - Push View Controller
    
    public func push(
        _ viewController: UIViewController,
        completion: (() -> Void)?
    ) {
        self.push(
            viewController,
            animated: true,
            completion: completion
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        self.push(
            viewController,
            animated: animated,
            completion: nil
        )
    }
    
    public func push(
        _ viewController: UIViewController
    ) {
        self.push(
            viewController,
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - Push View Controller, Removing View Controllers Matching Condition
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersWhere condition: @escaping (UIViewController) -> Bool,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let viewControllersToRemove = self.viewControllers.filter(condition)
        
        if all(
            viewController.navigationItem.leftBarButtonItem == nil,
            viewController.navigationItem.leftBarButtonItems?.isEmpty ?? true,
            viewControllersToRemove.count == self.viewControllers.count
        ) {
            viewController.navigationItem.leftBarButtonItem = .init(customView: .init())
        }
        
        self.push(
            viewController,
            animated: animated,
            completion: {
                self.viewControllers.removeAll(where: { viewController in
                    return viewControllersToRemove.contains(where: { $0 === viewController})
                })
                viewController.navigationItem.leftBarButtonItem = nil
                completion?()
            }
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersWhere condition: @escaping (UIViewController) -> Bool,
        completion: (() -> Void)?
    ) {
        self.push(
            viewController,
            removingViewControllersWhere: condition,
            animated: true,
            completion: completion
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersWhere condition: @escaping (UIViewController) -> Bool,
        animated: Bool
    ) {
        self.push(
            viewController,
            removingViewControllersWhere: condition,
            animated: animated,
            completion: nil
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersWhere condition: @escaping (UIViewController) -> Bool
    ) {
        self.push(
            viewController,
            removingViewControllersWhere: condition,
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - Push View Controller, Removing View Controllers
    
    public func push(
        _ viewController: UIViewController,
        removing viewControllersToRemove: [UIViewController],
        animated: Bool,
        completion: (() -> Void)?
    ) {
        self.push(
            viewController,
            removingViewControllersWhere: { viewController in
                return viewControllersToRemove.contains(where: { $0 === viewController})
            },
            animated: animated,
            completion: completion
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removing viewControllersToRemove: [UIViewController],
        completion: (() -> Void)?
    ) {
        self.push(
            viewController,
            removing: viewControllersToRemove,
            animated: true,
            completion: completion
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removing viewControllersToRemove: [UIViewController],
        animated: Bool
    ) {
        self.push(
            viewController,
            removing: viewControllersToRemove,
            animated: animated,
            completion: nil
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removing viewControllersToRemove: [UIViewController]
    ) {
        self.push(
            viewController,
            removing: viewControllersToRemove,
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - Push View Controller, Removing View Controllers After View Controller Matching Condition
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersAfterViewControllerWhere
        condition: (UIViewController) -> Bool,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        let viewControllersToRemove = Array(self.viewControllers.suffix(while: { !condition($0) }))
        
        self.push(
            viewController,
            removing: viewControllersToRemove,
            animated: animated,
            completion: completion
        )
    }
    public func push(
        _ viewController: UIViewController,
        removingViewControllersAfterViewControllerWhere condition: (UIViewController) -> Bool,
        completion: (() -> Void)?
    ) {
        self.push(
            viewController,
            removingViewControllersAfterViewControllerWhere: condition,
            animated: true,
            completion: completion
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersAfterViewControllerWhere condition: (UIViewController) -> Bool,
        animated: Bool
    ) {
        self.push(
            viewController,
            removingViewControllersAfterViewControllerWhere: condition,
            animated: animated,
            completion: nil
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersAfterViewControllerWhere condition: (UIViewController) -> Bool
    ) {
        self.push(
            viewController,
            removingViewControllersAfterViewControllerWhere: condition,
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - Push View Controller, Removing View Controllers After Specified View Controller
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersAfter previousViewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        self.push(
            viewController,
            removingViewControllersAfterViewControllerWhere: { $0 === previousViewController },
            animated: animated,
            completion: completion
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersAfter previousViewController: UIViewController,
        completion: (() -> Void)?
    ) {
        self.push(
            viewController,
            removingViewControllersAfter: previousViewController,
            animated: true,
            completion: completion
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersAfter previousViewController: UIViewController,
        animated: Bool
    ) {
        self.push(
            viewController,
            removingViewControllersAfter: previousViewController,
            animated: animated,
            completion: nil
        )
    }
    
    public func push(
        _ viewController: UIViewController,
        removingViewControllersAfter previousViewController: UIViewController
    ) {
        self.push(
            viewController,
            removingViewControllersAfter: previousViewController,
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - Pop To Specified View Controller
    
    public func pop(
        to viewController: UIViewController,
        completion: (() -> Void)?
    ) {
        self.pop(
            to: viewController,
            animated: true,
            completion: completion
        )
    }
    
    public func pop(
        to viewController: UIViewController,
        animated: Bool
    ) {
        self.pop(
            to: viewController,
            animated: animated,
            completion: nil
        )
    }
    
    public func pop(
        to viewController: UIViewController
    ) {
        self.pop(
            to: viewController,
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - Pop Top View Controller
    
    public func pop(
        animated: Bool,
        completion: (() -> Void)?
    ) {
        guard let viewController = self.viewControllers.dropLast().last else { return }
        
        self.pop(
            to: viewController,
            animated: animated,
            completion: completion
        )
    }
    
    public func pop(
        completion: (() -> Void)?
    ) {
        self.pop(
            animated: true,
            completion: completion
        )
    }
    
    public func pop(
        animated: Bool
    ) {
        self.pop(
            animated: animated,
            completion: nil
        )
    }
    
    public func pop() {
        self.pop(
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - Pop To Root View Controller
    
    public func popToRoot(
        animated: Bool,
        completion: (() -> Void)?
    ) {
        guard let viewController = self.viewControllers.first else { return }
        
        self.pop(
            to: viewController,
            animated: animated,
            completion: completion
        )
    }
    
    public func popToRoot(
        completion: (() -> Void)?
    ) {
        self.popToRoot(
            animated: true,
            completion: completion
        )
    }
    
    public func popToRoot(
        animated: Bool
    ) {
        self.popToRoot(
            animated: animated,
            completion: nil
        )
    }
    
    public func popToRoot() {
        self.popToRoot(
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - Pop To View Controller Matching Condition
    
    public func popToViewController(
        where condition: (UIViewController) -> Bool,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        guard let viewController = self.viewControllers.last(where: condition) else { return }
        
        self.pop(
            to: viewController,
            animated: animated,
            completion: completion
        )
    }
    
    public func popToViewController(
        where condition: (UIViewController) -> Bool,
        completion: (() -> Void)?
    ) {
        self.popToViewController(
            where: condition,
            animated: true,
            completion: completion
        )
    }
    
    public func popToViewController(
        where condition: (UIViewController) -> Bool,
        animated: Bool
    ) {
        self.popToViewController(
            where: condition,
            animated: animated,
            completion: nil
        )
    }
    
    public func popToViewController(
        where condition: (UIViewController) -> Bool
    ) {
        self.popToViewController(
            where: condition,
            animated: true,
            completion: nil
        )
    }
    
}
