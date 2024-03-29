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

extension Array where Element: UITextField {
    
    public func connect() {
        for (index, field) in self.enumerated() {
            if let nextField = self[safe: index+1] {
                field.addAction(for: .primaryActionTriggered, action: { [weak nextField] in
                    nextField?.becomeFirstResponder()
                })
            } else {
                field.addAction(for: .primaryActionTriggered, action: { [weak field] in
                    field?.resignFirstResponder()
                })
            }
        }
    }
    
}

extension UITextField {
    
    public func useReturnKeyToolbarAsInputAccessoryView(tintColor: UIColor? = nil) {
        self.inputAccessoryView = UIToolbar(returnKeyType: self.returnKeyType, tintColor: tintColor, action: { [weak self] in
            self?.sendActions(for: .editingDidEndOnExit)
        })
    }
    
}

extension UIReturnKeyType {
    
    public var title: String {
        switch self {
        case .go: return "Go"
        case .google: return "Google"
        case .join: return "Join"
        case .next: return "Next"
        case .route: return "Route"
        case .search: return "Search"
        case .send: return "Send"
        case .yahoo: return "Yahoo"
        case .done: return "Done"
        case .emergencyCall: return "Emergency Call"
        case .continue: return "Continue"
        case .default: fallthrough
        @unknown default: return "Return"
        }
    }
    
}
