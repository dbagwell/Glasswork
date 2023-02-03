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

import UIKit

extension UIViewController {
    
    public var topViewController: UIViewController {
        if let tabBar = self as? UITabBarController, let selectedTab = tabBar.selectedViewController {
            return selectedTab.topViewController
        } else if let nav = self as? UINavigationController, let visibleViewController = nav.visibleViewController {
            return visibleViewController.topViewController
        } else if let modal = self.presentedViewController {
            return modal.topViewController
        } else {
            return self
        }
    }
    
    public func showAlert(withTitle title: String? = nil, message: String? = nil) {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async(execute: {
                self.showAlert(withTitle: title, message: message)
            })
            
            return
        }
        
        self.present(UIAlertController.alert(withTitle: title, message: message), animated: true, completion: nil)
    }
    
    @discardableResult
    public func presentNavigationController(
        with viewController: UIViewController,
        fullScreen: Bool = false,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) -> UINavigationController {
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.dismiss))
        let navigationController = UINavigationController(rootViewController: viewController)
        
        if fullScreen {
            navigationController.modalPresentationStyle = .fullScreen
        }
        
        self.present(navigationController, animated: animated, completion: completion)
        
        return navigationController
    }
    
    public func present(
        _ viewController: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        self.present(
            viewController,
            animated: true,
            completion: completion
        )
    }
    
    @objc public func dismiss(
        completion: (() -> Void)? = nil
    ) {
        self.dismiss(
            animated: true,
            completion: completion
        )
    }
    
    public func overlay(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController.transitioningDelegate = OverlayTransitioningDelegate.shared
        viewController.modalPresentationStyle = .custom
        self.present(viewController, animated: animated, completion: completion)
    }
    
}
