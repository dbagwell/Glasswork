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
    
    public let styles: Styles
    
    public var hasError = false {
        didSet {
            self.apply(self.isFirstResponder ? self.styles.focusedError : self.styles.error)
        }
    }
    
    private var widthConstraint: Constraint? {
        willSet {
            self.widthConstraint?.deactivate()
        }
    }
    
    private var heightConstraint: Constraint? {
        willSet {
            self.heightConstraint?.deactivate()
        }
    }
    
    
    // MARK: - Init
    
    public init(styles: Styles) {
        self.styles = styles
        
        super.init(frame: .zero)
        
        self.apply(self.styles.default)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UIResponder
    
    override public func becomeFirstResponder() -> Bool {
        self.apply(self.hasError ? self.styles.focusedError : self.styles.focused)
        return super.becomeFirstResponder()
    }
    
    override public func resignFirstResponder() -> Bool {
        self.apply(self.hasError ? self.styles.error : self.styles.default)
        return super.resignFirstResponder()
    }
    
    
    // MARK: - Methods
    
    private func apply(_ style: Style) {
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
        
        self.widthConstraint = nil
        self.heightConstraint = nil
        
        self.snp.makeConstraints({ make in
            make.height.equalTo(style.height)
            if let width = style.width {
                make.width.equalTo(width)
            }
        })
    }
    
}
