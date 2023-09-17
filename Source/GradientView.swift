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
    
    open var colors: [UIColor] {
        didSet {
            self.gradientLayer.colors = self.colors.map({ $0.cgColor })
        }
    }
    
    private var gradientLayer = CAGradientLayer()
    private let direction: Direction
    private var cornerRadiusObservation: NSKeyValueObservation?
    
    // MARK: Init
    
    @available(*, deprecated, message: "Set the corner radius of the layer instead.")
    public init(colors: [UIColor], cornerRadius: CGFloat = 0.0, direction: Direction) {
        self.colors = colors
        self.direction = direction
        
        super.init(frame: .zero)
        
        self.setBorder(radius: cornerRadius)
        self.updateGradient()
        
        self.cornerRadiusObservation = self.layer.observe(\.cornerRadius, changeHandler: { _, _ in
            self.updateGradient()
        })
    }
    
    public init(colors: [UIColor], direction: Direction) {
        self.colors = colors
        self.direction = direction
        
        super.init(frame: .zero)
        
        self.updateGradient()
        
        self.cornerRadiusObservation = self.layer.observe(\.cornerRadius, changeHandler: { _, _ in
            self.updateGradient()
        })
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }
    
    @available(*, deprecated, message: "Use the colors property instead.")
    public func updateColors(_ colors: [UIColor]) {
        self.colors = colors
    }
    
    private func updateGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = self.colors.map({ $0.cgColor })
        gradientLayer.startPoint = self.direction.startPoint()
        gradientLayer.endPoint = self.direction.endPoint()
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer.removeFromSuperlayer()
        self.gradientLayer = gradientLayer
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.gradientLayer.colors = self.colors.map({ $0.cgColor })
    }
    
}
