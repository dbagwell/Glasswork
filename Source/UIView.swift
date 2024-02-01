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
import Rebar
import SnapKit

extension UIView {
    
    // MARK: - Adding / Removing Subviews
    
    public func addSubview(_ view: UIView, _ makeConstraintsBlock: @escaping (ConstraintMaker) -> Void) {
        self.addSubview(view)
        view.snp.makeConstraints(makeConstraintsBlock)
    }
    
    public func removeAllSubviews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    // MARK: - Color Related
    
    public var superBackgroundColor: UIColor? {
        if let color = self.superview?.backgroundColor, color != .clear {
            return color
        } else {
            return self.superview?.superBackgroundColor
        }
    }
    
    // MARK: - Hiding
    
    /// The inverse of `isHidden`.
    /// Also a workaround for a bug as described below:
    /// When a view is in a stack view  the `isHidden` property keeps a cumulative tally of when it's set.
    /// ie: if it is set to `false` when it's already `false` it needs to be set to `true` twice to actually be set to true.
    /// There is an open radar bug about this issue here http://www.openradar.me/25087688 .
    /// This property makes sure to only set `isHidden` if the if it's a different value so as to avoid this issue.
    public var isRendered: Bool {
        get {
            return !self.isHidden
        }
        set {
            if self.isHidden == newValue {
                self.isHidden = !newValue
            }
        }
    }
    
    
    // MARK: - Simple Preset Views
    
    public static func emptyWidth(_ width: CGFloat) -> UIView {
        let view = UIView()
        view.snp.makeConstraints({ make in
            make.width.equalTo(width)
        })
        
        return view
    }
    
    public static func emptyHeight(_ height: CGFloat) -> UIView {
        let view = UIView()
        view.snp.makeConstraints({ make in
            make.height.equalTo(height)
        })
        
        return view
    }
    
    public static func color(_ color: UIColor, withWidth width: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.snp.makeConstraints({ make in
            make.width.equalTo(width)
        })
        
        return view
    }
    
    public static func color(_ color: UIColor, withHeight height: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.snp.makeConstraints({ make in
            make.height.equalTo(height)
        })
        
        return view
    }
    
    
    // MARK: - Border
    
    public func setBorder(
        width: CGFloat? = nil,
        color: UIColor? = nil,
        radius: CGFloat? = nil
    ) {
        if let width = width {
            self.layer.borderWidth = width
        }
        
        if let color = color {
            self.layer.borderColor = color.cgColor
        }
        
        if let radius = radius {
            self.layer.cornerRadius = radius
        }
    }
    
    public func clearBorder() {
        self.setBorder(width: 0, color: .clear, radius: 0)
    }
    
    
    // MARK: - Shadows
    
    public func addShadow(
        color: UIColor = UIColor.black.withAlphaComponent(0.2),
        radius: CGFloat = 3,
        offset: CGSize = .init(width: 0, height: -3),
        opacity: Float = 1
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
    }
    
    public func removeShadow() {
        self.layer.shadowOpacity = 0
    }
    
    
    // MARK: - Padding
    
    /// - Returns: This view wrapped in a view and inset by `insets`.
    public func inset(by insets: UIEdgeInsets) -> UIView {
        let view = UIView()
        
        view.addSubview(self, { make in
            make.edges.equalToSuperview().inset(insets)
        })
        
        return view
    }
    
    
    // MARK: - Keyboard Observation
    
    /// - Returns: This view wrapped in a view that will automatically adjust its constraints
    /// so as not to be obscured by the keyboard.
    /// - Note: Make sure to decrease the priority of any constraints with this view appropriately
    /// to avoid conflicts with the constraints that move it out of the way of the keyboard.
    public func keyboardObserving() -> UIView {
        let view = KeyboardObservingView()
        
        view.addSubview(self, { make in
            make.edges.equalToSuperview()
        })
        
        return view
    }
    
    
    // MARK: - Activity View
    
    public static var activityViewClass: ActivityView.Type = DefaultActivityView.self
    
    private var currentActivityView: ActivityView? {
        return self.subviews.compactMap({ $0 as? ActivityView }).first
    }
    
    public func showActivityView(withTitle title: String? = nil) {
        if let currentActivityView = self.currentActivityView {
            currentActivityView.title = title
            return
        }
        
        UIView.activityViewClass.init(title: title).show(on: self)
    }
    
    public func hideActivityView() {
        self.currentActivityView?.hide()
    }
    
    public func performActivity(_ activity: (@escaping (Result<Void, String>) -> Void) -> Void, withTitle title: String? = nil) {
        self.showActivityView(withTitle: title)
        
        activity({ result in
            DispatchQueue.asyncToMainIfNeeded(execute: {
                self.hideActivityView()
                
                switch result {
                case .success:
                    break
                    
                case let .failure(errorMessage):
                    self.window?.showAlert(message: errorMessage)
                }
            })
        })
    }
    
}
