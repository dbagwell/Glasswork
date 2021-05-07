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

open class GradientView: UIView {
    
    // MARK: Enum
    
    public enum Direction {
        case vertical
        case horizontal
        
        fileprivate func startPoint() -> CGPoint {
            switch self {
            case .horizontal:
                return CGPoint(x: 0, y: 0)
            case .vertical:
                return CGPoint(x: 0, y: 0)
            }
        }
        
        fileprivate func endPoint() -> CGPoint {
            switch self {
            case .horizontal:
                return CGPoint(x: 1, y: 0)
            case .vertical:
                return CGPoint(x: 0, y: 1)
            }
        }
    }
    
    // MARK: Properties
    
    private var gradientLayer = CAGradientLayer()
    private let direction: Direction
    
    // MARK: Init
    
    public init(colors: [UIColor], cornerRadius: CGFloat = 0.0, direction: Direction) {
        self.direction = direction
        
        super.init(frame: .zero)
        
        self.addGradientToSublayer(colors: colors, cornerRadius: cornerRadius)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }
    
    public func updateColors(_ colors: [UIColor]) {
        self.gradientLayer.colors = colors.map({ $0.cgColor })
    }
    
    private func addGradientToSublayer(colors: [UIColor], cornerRadius: CGFloat = 0.0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map({ $0.cgColor })
        gradientLayer.startPoint = self.direction.startPoint()
        gradientLayer.endPoint = self.direction.endPoint()
        gradientLayer.cornerRadius = cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
    
}
