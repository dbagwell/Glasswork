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

extension UIAlertController {
    
    public static func alert(withTitle title: String? = nil, message: String? = nil, action: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            action?()
        }))
        
        return alert
    }
    
    public convenience init(
        style: UIAlertController.Style,
        title: String? = nil,
        message: String? = nil,
        sourceView: UIView? = nil,
        actions: [UIAlertAction]
    ) {
        self.init(title: title, message: message, preferredStyle: style)
        actions.forEach({ self.addAction($0) })
        self.popoverPresentationController?.sourceView = sourceView
    }
    
}

extension UIAlertAction {
    
    public convenience init(
        title: String,
        style: UIAlertAction.Style = .default,
        action: (() -> Void)? = nil
    ) {
        let handler: ((UIAlertAction) -> Void)? = action != nil ? { _ in action?() } : nil
        self.init(title: title, style: style, handler: handler)
    }
    
}
