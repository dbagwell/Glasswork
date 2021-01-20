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

public protocol UINavigationBarStyling where Self: UIViewController {
    
    var navigationBarStyle: UINavigationBar.Style? { get set }
    
}

extension UINavigationBarStyling {
    
    /// If the class is a UINavigationController, it styles its own navigationBar using its navigationBarStyle,
    /// Otherwise, style the referenced navigationController's navigationBar using the following waterfall:
    /// Use our navigationBarStyle,
    /// Use the navigationBarStyle of the previous viewController in the navigationController's navigation stack,
    /// Use the navigationBarStyle of the navigationController,
    /// Use the default navigationBarStyle
    ///
    /// This should usually be called in viewWillAppear of UIViewControllers
    public func styleNavigationBar() {
        if let navigationController = self as? UINavigationController {
            navigationController.navigationBar.style(with: self.navigationBarStyle ?? .default)
            return
        }
        
        // Only direct children of the navigation controller are allowed to style the navigation bar
        guard let navigationController = self.parent as? UINavigationController else { return }
        
        let previousViewController = navigationController.viewControllers.dropLast().last as? UINavigationBarStyling
        let previousStyle = previousViewController?.navigationBarStyle
        let stylingNavigationController = navigationController as? UINavigationBarStyling
        let navStyle = stylingNavigationController?.navigationBarStyle
        
        let style = self.navigationBarStyle ?? previousStyle ?? navStyle ?? UINavigationBar.Style.default
        
        self.navigationBarStyle = style
        navigationController.navigationBar.style(with: style)
        self.navigationItem.titleView = style.titleView?()
    }
    
    /// Changes the navigationBarStyle back to the one in the navigationBarStyle of the previous viewController in the navigationController's navigation stack
    /// This will allow changes in navigation bar style to be animated when poping a view controller from the navigation stack
    /// Should usually be called in UIViewController's willMove(toParentViewController:) when the parent is nil
    public func revertToPreviousNavigationBarStyle() {
        guard
            let navigationController = self.parent as? UINavigationController, // Only direct children of the navigation controller are allowed to style the navigation bar
            let previousViewController = navigationController.viewControllers.dropLast().last as? UINavigationBarStyling
        else { return }
        
        previousViewController.styleNavigationBar()
    }
    
}
