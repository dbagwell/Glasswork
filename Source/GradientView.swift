//
//  GradientView.swift
//  Glasswork
//
//  Created by David Bagwell on 2021-04-14.
//  Copyright © 2021 David Bagwell. All rights reserved.
//

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
