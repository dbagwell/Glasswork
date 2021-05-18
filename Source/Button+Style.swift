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

extension Button {
    
    public struct Style {
        
        // MARK: - Properties
        
        public let textFamily: UIFont.Family
        public let textWeight: UIFont.Weight
        public let textSize: CGFloat
        public let textColor: UIColor
        public let textAlignment: NSTextAlignment
        public let horizontalTextPadding: CGFloat
        public let borderWidth: CGFloat
        public let cornerRadius: CGFloat
        public let borderColor: UIColor
        public let backgroundColor: UIColor
        public let width: CGFloat?
        public let height: CGFloat
        
        
        // MARK: Init
        
        public init(
            textFamily: UIFont.Family,
            textWeight: UIFont.Weight,
            textSize: CGFloat,
            textColor: UIColor,
            textAlignment: NSTextAlignment,
            horizontalTextPadding: CGFloat = 0,
            borderWidth: CGFloat = 0,
            cornerRadius: CGFloat = 0,
            borderColor: UIColor = .clear,
            backgroundColor: UIColor = .clear,
            width: CGFloat? = nil,
            height: CGFloat
        ) {
            self.textFamily = textFamily
            self.textWeight = textWeight
            self.textSize = textSize
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.horizontalTextPadding = horizontalTextPadding
            self.borderWidth = borderWidth
            self.cornerRadius = cornerRadius
            self.borderColor = borderColor
            self.backgroundColor = backgroundColor
            self.width = width
            self.height = height
        }
        
        
        // MARK: - Methods
        
        public func customized(
            textFamily: UIFont.Family? = nil,
            textWeight: UIFont.Weight? = nil,
            textSize: CGFloat? = nil,
            textColor: UIColor? = nil,
            textAlignment: NSTextAlignment? = nil,
            horizontalTextPadding: CGFloat? = nil,
            borderWidth: CGFloat? = nil,
            cornerRadius: CGFloat? = nil,
            borderColor: UIColor? = nil,
            backgroundColor: UIColor? = nil,
            width: CGFloat? = nil,
            height: CGFloat? = nil
        ) -> Style {
            return Style(
                textFamily: textFamily ?? self.textFamily,
                textWeight: textWeight ?? self.textWeight,
                textSize: textSize ?? self.textSize,
                textColor: textColor ?? self.textColor,
                textAlignment: textAlignment ?? self.textAlignment,
                horizontalTextPadding: horizontalTextPadding ?? self.horizontalTextPadding,
                borderWidth: borderWidth ?? self.borderWidth,
                cornerRadius: cornerRadius ?? self.cornerRadius,
                borderColor: borderColor ?? self.borderColor,
                backgroundColor: backgroundColor ?? self.backgroundColor,
                width: width ?? self.width,
                height: height ?? self.height
            )
        }
        
    }
    
}
