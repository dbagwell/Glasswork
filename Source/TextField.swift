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
import SnapKit
import UIKit

public final class TextField: UITextField {
    
    // MARK: - Properties
    
    private var currentStyle: Style
    
    public var styles: Styles {
        didSet {
            self.updateStyle()
        }
    }
    
    public var hasError = false {
        didSet {
            self.updateStyle()
        }
    }
    
    
    // MARK: - Init
    
    public init(styles: Styles) {
        self.styles = styles
        self.currentStyle = styles.default
        
        super.init(frame: .zero)
        
        self.apply(self.styles.default)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UIResponder
    
    override public func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.updateStyle()
        return result
    }
    
    override public func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        self.updateStyle()
        return result
    }
    
    
    // MARK: - UITextField
    
    private func realTextRect(forBounds bounds: CGRect) -> CGRect {
        return self.layer.borderWidth > 0 ? bounds.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)) : bounds
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.realTextRect(forBounds: bounds)
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.realTextRect(forBounds: bounds)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.realTextRect(forBounds: bounds)
    }
    
    
    // MARK: - Methods
    
    private func updateStyle() {
        if self.hasError {
            self.apply(self.isFirstResponder ? self.styles.focusedError : self.styles.error)
        } else {
            self.apply(self.isFirstResponder ? self.styles.focused : self.styles.default)
        }
    }
    
    private func apply(_ style: Style) {
        self.currentStyle = style
        
        DispatchQueue.asyncToMainIfNeeded(execute: {
            self.font = style.textFamily.font(ofSize: style.textSize, weight: style.textWeight)
            self.textColor = style.textColor
            self.textAlignment = style.textAlignment
            self.layer.borderWidth = style.borderWidth
            self.layer.borderColor = style.borderColor.cgColor
            self.layer.cornerRadius = style.cornerRadius
            self.backgroundColor = style.backgroundColor
            self.tintColor = style.tintColor
            self.keyboardType = style.keyboardType
            self.textContentType = style.textContentType
            self.autocapitalizationType = style.autocapitalizationType
            self.autocorrectionType = style.autocorrectionType
            self.returnKeyType = style.returnKeyType
        })
    }
    
    public override var intrinsicContentSize: CGSize {
        return .init(width: self.currentStyle.width ?? super.intrinsicContentSize.width, height: self.currentStyle.height)
    }
    
}
