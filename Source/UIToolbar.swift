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

extension UIToolbar {
    
    /// Creates a toolbar with a single button on it's right hand side.
    /// The title of the button matches the returnKeyType.
    convenience init(returnKeyType: UIReturnKeyType, tintColor: UIColor? = nil, action: @escaping () -> Void) {
        self.init(rightButtonTitle: returnKeyType.title, tintColor: tintColor, action: action)
    }
    
    /// Creates a toolbar with a single button on it's right hand side.
    convenience init(rightButtonTitle: String, tintColor: UIColor? = nil, action: @escaping () -> Void) {
        let returnButton = UIBarButtonItem(title: rightButtonTitle, style: .done, target: nil, action: nil)
        returnButton.tintColor = tintColor
        returnButton.addAction(action)
        
        self.init(frame: .init(x: 0, y: 0, width: 0, height: 44))
        self.isTranslucent = true
        self.setContentHuggingPriority(.required, for: .vertical)
        self.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            returnButton,
        ]
    }
    
}
