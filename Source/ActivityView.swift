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

public protocol ActivityView: UIView {
    init(title: String?)
    var title: String? { get set }
    func show(on superview: UIView)
    func hide()
}

public class DefaultActivityView: UIView, ActivityView {
    
    // MARK: - Properties
    
    public var title: String? {
        get {
            return self.titleLabel.text
        } set {
            self.titleLabel.text = newValue
        }
    }
    
    
    // MARK: - Subviews
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.color = .gray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalSpacing
        view.addArrangedSubview(self.activityIndicatorView)
        view.addArrangedSubview(.emptyHeight(10))
        view.addArrangedSubview(self.titleLabel)
        return view
    }()
    
    private lazy var effectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        view.contentView.addSubview(self.stackView, { make in
            make.edges.equalToSuperview().inset(20)
        })
        
        return view
    }()
    
    
    // MARK: - Init
    
    public required init(title: String? = nil) {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.alpha = 0
        self.effectView.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
        
        self.title = title
        
        self.addSubview(self.effectView, { make in
            make.center.equalToSuperview()
            make.top.left.greaterThanOrEqualToSuperview()
            make.bottom.right.lessThanOrEqualToSuperview()
        })
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    public func show(on superview: UIView) {
        superview.addSubview(self, { make in
            make.edges.equalToSuperview()
        })
        
        self.activityIndicatorView.startAnimating()
        
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.effectView.transform = .identity
        }, completion: nil)
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.alpha = 0
            self.effectView.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
}
