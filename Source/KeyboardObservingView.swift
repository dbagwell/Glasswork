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

import SnapKit
import UIKit

public final class KeyboardObservingView: UIView {
    
    private var bottomConstraint: Constraint? {
        willSet {
            self.bottomConstraint?.deactivate()
        }
    }
    
    override public func didMoveToWindow() {
        if self.window == nil {
            self.unregisterForKeyboardNotifications()
        } else {
            self.registerForKeyboardNotifications()
        }
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if
            let userInfo = notification.userInfo,
            let superview = self.superview,
            let window = self.window,
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject?)?.doubleValue
        {
            self.snp.makeConstraints({ make in
                self.bottomConstraint = make.bottom.lessThanOrEqualTo(window.snp.bottom).inset(keyboardSize.height).constraint
            })
            
            UIView.animate(withDuration: duration, animations: {
                superview.layoutIfNeeded()
            })
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if
            let userInfo = notification.userInfo,
            let superview = self.superview,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject?)?.doubleValue
        {
            self.bottomConstraint = nil
            
            UIView.animate(withDuration: duration, animations: {
                superview.layoutIfNeeded()
            })
        }
    }
    
}
