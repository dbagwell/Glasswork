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

extension UINavigationBar {
    
    public struct Style {
        
        // MARK: - Default Style
        
        public static var `default` = Style(
            backgroundColor: .white,
            foregroundColor: .black,
            barStyle: .black
        )
        
        
        // MARK: - Properties
        
        public let backgroundColor: UIColor
        public let foregroundColor: UIColor
        public let barStyle: UIBarStyle
        public let titleFont: UIFont?
        public let titleColor: UIColor?
        public let titleView: (() -> UIView)?
        
        
        // MARK: - Init
        
        public init(
            backgroundColor: UIColor,
            foregroundColor: UIColor,
            barStyle: UIBarStyle,
            titleFont: UIFont? = nil,
            titleColor: UIColor? = nil,
            titleView: (() -> UIView)? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.barStyle = barStyle
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.titleView = titleView
        }
        
    }
    
    public func style(with style: Style) {
        self.barStyle = style.barStyle
        self.isTranslucent = style.backgroundColor == .clear
        self.tintColor = style.foregroundColor
        self.barTintColor = style.backgroundColor
        self.backgroundColor = style.backgroundColor
        self.setBackgroundImage(UIColor.clear.image, for: .default)
        self.shadowImage = UIImage()
        
        if self.titleTextAttributes == nil {
            self.titleTextAttributes = [.foregroundColor: style.titleColor ?? style.foregroundColor]
        } else {
            self.titleTextAttributes?[.foregroundColor] = style.titleColor ?? style.foregroundColor
        }
        
        if let font = style.titleFont {
            self.titleTextAttributes?[.font] = font
        }
    }
    
}
