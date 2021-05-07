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

public final class BackgroundDimmingInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    private weak var responder: UIResponder?
    
    
    // MARK: - UI
    
    private lazy var dimmingView: UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addAction(for: .touchUpInside, action: { [weak self] in
            self?.responder?.resignFirstResponder()
        })
        
        return view
    }()
    
    
    // MARK: - Init
    
    public init(
        responder: UIResponder,
        showToolbar: Bool = true,
        selectButtonAction: (() -> Void)? = nil
    ) {
        self.responder = responder
        
        super.init(frame: .zero)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.hideDimmingView),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UIView
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        guard let window = self.window else { return }
        
        window.addSubview(self.dimmingView)
        self.dimmingView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        self.dimmingView.alpha = 0
            
        // There's some kind of rendering glicth the first time an input view is shown
        // that causes the animation to not work unless dispatched
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 0.25, animations: {
                self.dimmingView.alpha = 1
            })
        })
    }
    
    
    // MARK: - Methods
    
    @objc private func hideDimmingView() {
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.dimmingView.alpha = 0
            },
            completion: { _ in
                self.dimmingView.removeFromSuperview()
            }
        )
    }
    
}
