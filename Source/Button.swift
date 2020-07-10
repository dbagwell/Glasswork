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

public final class Button: UIControl {
    
    // MARK: - Properties
    
    public let style: Style
    
    override public var primaryAction: UIControl.Event {
        return .touchUpInside
    }
    
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel(
            style: UILabel.Style(
                family: self.style.textFamily,
                weight: self.style.textWeight,
                size: self.style.textSize,
                color: self.style.textColor,
                alignment: self.style.textAlignment,
                lineLimit: 1,
                minimumScale: 1
            )
        )
        
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.borderWidth = self.style.borderWidth
        view.layer.cornerRadius = self.style.cornerRadius
        view.layer.borderColor = self.style.borderColor.cgColor
        view.backgroundColor = self.style.backgroundColor
        
        view.addSubview(titleLabel, { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        })
        
        return view
    }()
    
    
    // MARK: - Init
    
    public init(title: String? = nil, style: Style, action: (() -> Void)? = nil) {
        self.style = style
        
        super.init(frame: .zero)
        
        self.layer.cornerRadius = self.style.cornerRadius
        self.backgroundColor = .white
        self.titleLabel.text = title
        
        if let action = action {
            self.addAction(action: action)
        }
        
        self.addSubview(self.contentView, { make in
            make.edges.equalToSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UIControl
    
    override public var isHighlighted: Bool {
        didSet {
            guard self.isEnabled else { return }
            UIView.animate(withDuration: self.isHighlighted ? 0 : 0.25, animations: {
                self.contentView.alpha = self.isHighlighted ? 0.2 : 1
            })
        }
    }
    
    override public var isEnabled: Bool {
        didSet {
            self.contentView.alpha = self.isHighlighted || !self.isEnabled ? 0.2 : 1
        }
    }
    
    
    // MARK: - UIView
    
    override public var intrinsicContentSize: CGSize {
        return .init(width: self.style.width ?? super.intrinsicContentSize.width, height: self.style.height)
    }
    
}
