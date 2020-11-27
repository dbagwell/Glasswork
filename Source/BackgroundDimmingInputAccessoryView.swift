//
//  BackgroundDimmingInputAccessoryView.swift
//  Glasswork
//
//  Created by David Bagwell on 2020-07-30.
//  Copyright © 2020 David Bagwell. All rights reserved.
//

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
