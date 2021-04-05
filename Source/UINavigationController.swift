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

extension UINavigationController {
    
    /// Pushes the provided view controller onto the navigation stack in an animated fashion with the provided completion.
    public func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        self.pushViewController(viewController, animated: true, completion: completion)
    }
    
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        self.pushViewController(viewController, animated: animated)
        self.callCompletionAfterTransition(completion, animated: animated)
    }
    
    /// Pops the last view controller on the navigation stack in an animated fashion with the provided completion.
    public func popViewController(completion: (() -> Void)? = nil) {
        self.popViewController(animated: true, completion: completion)
    }
    
    public func popViewController(animated: Bool, completion: (() -> Void)?) {
        self.popViewController(animated: animated)
        self.callCompletionAfterTransition(completion, animated: animated)
    }
    
    /// Pops to the specified view controller in an animated fashion with the provided completion, if it is in the navigation stack.
    public func popToViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        self.popToViewController(viewController, animated: true, completion: completion)
    }
    
    public func popToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        self.popToViewController(viewController, animated: animated)
        self.callCompletionAfterTransition(completion, animated: animated)
    }
    
    /// Pops to the root view controller of the navigation stack in an animated fashion with the provided completion.
    public func popToRootViewController(completion: (() -> Void)? = nil) {
        self.popToRootViewController(animated: true, completion: completion)
    }
    
    public func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        self.popToRootViewController(animated: animated)
        self.callCompletionAfterTransition(completion, animated: animated)
    }
    
    private func callCompletionAfterTransition(_ completion: (() -> Void)?, animated: Bool) {
        if let coordinator = self.transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil, completion: { _ in
                completion?()
            })
        } else {
            DispatchQueue.main.async(execute: {
                completion?()
            })
        }
    }
    
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool = true,
        removingPreviousViewControllers viewControllersToRemove: [UIViewController],
        completion: (() -> Void)? = nil
    ) {
        self.pushViewController(
            viewController,
            animated: animated,
            removingPreviousViewControllersWhere: { viewController in
                viewControllersToRemove.contains(where: { $0 === viewController })
            },
            completion: completion
        )
    }
    
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool = true,
        removingPreviousViewControllersWhere condition: @escaping (UIViewController) -> Bool,
        completion: (() -> Void)? = nil
    ) {
        self.pushViewController(viewController, animated: animated, completion: {
            self.viewControllers.removeAll(where: condition)
            completion?()
        })
    }
    
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool = true,
        removingViewControllersAfter previousViewController: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        let viewControllersToRemove = self.viewControllers.suffix(while: { $0 !== previousViewController })
        self.pushViewController(viewController, animated: animated, completion: {
            self.viewControllers.removeAll(where: { viewController in
                viewControllersToRemove.contains(where: { $0 === viewController })
            })
            
            completion?()
        })
    }
    
}

