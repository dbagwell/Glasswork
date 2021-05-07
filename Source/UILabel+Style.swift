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

extension UILabel {
    
    public struct Style {
        
        // MARK: - Properties
        
        public let family: UIFont.Family
        public let weight: UIFont.Weight
        public let size: CGFloat
        public let color: UIColor
        public let alignment: NSTextAlignment
        public let lineLimit: Int
        public let minimumScale: CGFloat
        
        public var font: UIFont {
            return self.family.font(ofSize: self.size, weight: self.weight)
        }
        
        
        // MARK: - Init
        
        public init(
            family: UIFont.Family,
            weight: UIFont.Weight,
            size: CGFloat,
            color: UIColor,
            alignment: NSTextAlignment,
            lineLimit: Int = 0,
            minimumScale: CGFloat = 1
        ) {
            self.family = family
            self.weight = weight
            self.size = size
            self.color = color
            self.alignment = alignment
            self.lineLimit = lineLimit
            self.minimumScale = minimumScale
        }
        
        
        // MARK: - Methods
        
        public func customized(
            family: UIFont.Family? = nil,
            weight: UIFont.Weight? = nil,
            size: CGFloat? = nil,
            color: UIColor? = nil,
            alignment: NSTextAlignment? = nil,
            lineLimit: Int? = nil,
            minimumScale: CGFloat? = nil
        ) -> Style {
            return Style(
                family: family ?? self.family,
                weight: weight ?? self.weight,
                size: size ?? self.size,
                color: color ?? self.color,
                alignment: alignment ?? self.alignment,
                lineLimit: lineLimit ?? self.lineLimit,
                minimumScale: minimumScale ?? self.minimumScale
            )
        }
        
    }
    
    public convenience init(text: String? = nil, style: Style) {
        self.init()
        self.text = text
        self.set(style)
    }
    
    public func set(_ style: Style) {
        self.font = style.family.font(ofSize: style.size, weight: style.weight)
        self.textColor = style.color
        self.textAlignment = style.alignment
        self.numberOfLines = style.lineLimit
        self.minimumScaleFactor = style.minimumScale
        self.adjustsFontSizeToFitWidth = style.minimumScale != 1
    }
    
}
