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
    
    public func addSubview(_ view: UIView, _ makeConstraintsBlock: @escaping (ConstraintMaker) -> Void) {
        self.addSubview(view)
        view.snp.makeConstraints(makeConstraintsBlock)
    }
    
    public static func emptyHeight(_ height: CGFloat) -> UIView {
        let view = UIView()
        view.snp.makeConstraints({ make in
            make.height.equalTo(height)
        })
        
        return view
    }
    
    public static func emptyWidth(_ width: CGFloat) -> UIView {
        let view = UIView()
        view.snp.makeConstraints({ make in
            make.height.equalTo(width)
        })
        
        return view
    }
    
}

extension UIView {
    
    private var currentActivityView: ActivityView? {
        return self.subviews.compactMap({ $0 as? ActivityView }).first
    }
    
    public func showActivityView(withTitle title: String? = nil) {
        if let currentActivityView = self.currentActivityView {
            currentActivityView.title = title
            return
        }
        
        ActivityView(title: title).show(on: self)
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
                    UIApplication.shared.showAlert(message: errorMessage)
                }
            })
        })
    }
    
}
