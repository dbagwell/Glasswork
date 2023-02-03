//
//  OverlayTransition.swift
//  UI
//
//  Created by David Bagwell on 2020-07-06.
//  Copyright © 2020 Lumeca Health. All rights reserved.
//

import SnapKit
import UIKit

public final class OverlayTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    public static let shared = OverlayTransitioningDelegate()
    
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return OverlayPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return OverlayAnimatedTransitioning()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OverlayAnimatedTransitioning()
    }
    
}

public final class OverlayAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {}, completion: { complete in
            transitionContext.completeTransition(complete)
        })
    }
    
}

public final class OverlayPresentationController: UIPresentationController {
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let blurEffect = UIBlurEffect(style: .dark)
    
    private lazy var backgroundView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: nil)
        
        view.contentView.addSubview(self.overlayView, { make in
            make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide).inset(10)
            make.left.right.equalToSuperview().inset(10)
            
            // Offscreen Constraint (disable this to bring it on screen)
            self.cardOffscreenConstraint = make.top.equalTo(view.snp.bottom).constraint
            
            // Onscreen Constraints (conflict with offscreen constraint but have lower priority, so are ignored until it's disabled).
            make.centerY.equalToSuperview().priority(.low)
            make.height.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-20).priority(.high)
        })
        
        return view
    }()
    
    private var cardOffscreenConstraint: Constraint?
    
    public override func presentationTransitionWillBegin() {
        if let presentedView = self.presentedView {
            self.overlayView.addSubview(presentedView, { make in
                make.edges.equalToSuperview()
            })
        }
        
        self.containerView?.addSubview(self.backgroundView, { make in
            make.edges.equalToSuperview()
        })
        
        self.containerView?.layoutIfNeeded()
        
        self.cardOffscreenConstraint?.deactivate()
        
        guard let coordinator = self.presentedViewController.transitionCoordinator, coordinator.isAnimated else { return }
        
        coordinator.animate(alongsideTransition: { _ in
            self.backgroundView.effect = self.blurEffect
            self.containerView?.layoutIfNeeded()
        })
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        self.backgroundView.effect = self.blurEffect
        
        // For some reason, if the transition isn't animated,
        // the presented view gets removed from the card view during the "transition",
        // so we add it again here to be safe.
        if let presentedView = self.presentedView {
            self.overlayView.addSubview(presentedView, { make in
                make.edges.equalToSuperview()
            })
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        self.cardOffscreenConstraint?.activate()
        
        guard let coordinator = self.presentedViewController.transitionCoordinator, coordinator.isAnimated else { return }
        
        coordinator.animate(alongsideTransition: { _ in
            self.backgroundView.effect = nil
            self.containerView?.layoutIfNeeded()
        })
    }
    
}
