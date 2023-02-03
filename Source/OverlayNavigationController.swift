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

/// A navigation controller that sizes its view to match the size of its top view controller.
/// Use this when you want to present a navigation controller with the overlay transtion so that the auto layout magic works.
/// View controllers added to this navigation stack should set `extendedLayoutIncludesOpaqueBars` to true, and subviews should be kept within the safe area.
public final class OverlayNavigationController: UINavigationController {
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.snp.remakeConstraints({ make in
            make.top.left.greaterThanOrEqualToSuperview()
            make.bottom.right.lessThanOrEqualToSuperview()
        })
        
        if
            let viewController = self.viewControllers.last,
            viewController.view.superview != nil
        {
            viewController.view.snp.remakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if
            let viewController = self.viewControllers.last,
            viewController.view.superview != nil
        {
            viewController.view.snp.remakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        }
    }
    
}
