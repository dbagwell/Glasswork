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

open class SegmentedViewController: UIViewController {
    
    public struct Segment {
        
        public let id = UUID()
        public let title: String
        public fileprivate(set) var badgeText: String?
        public let viewController: UIViewController
        
        public init(title: String, badgeText: String?, viewController: UIViewController) {
            self.title = title
            self.badgeText = badgeText
            self.viewController = viewController
        }
        
    }
    
    // MARK: - Properties
    
    private let backgroundColor: UIColor
    private let inactiveSegmentTitleStyle: UILabel.Style
    private let activeSegmentTitleStyle: UILabel.Style
    private let segmentBadgeTextStyle: UILabel.Style
    private let segmentBadgeColor: UIColor
    private let segmentSeparatorColor: UIColor
    
    public var segments: [Segment] {
        didSet {
            self.separatorView.isHidden = self.segments.count <= 1
            self.segmentStackView.isHidden = self.segments.count <= 1
            
            self.segmentButtons = self.segments.map({ segment in
                let button = self.segmentButton(for: segment)
                button.viewModel.badgeText = segment.badgeText
                return button
            })
            
            if !self.segments.contains(where: { $0.id == self.activeSegment?.id }) {
                self.activeSegment = self.segments.first
            }
        }
    }
    
    private var activeSegment: Segment? {
        willSet {
            self.activeViewController?.willMove(toParent: nil)
            self.containerView.removeAllSubviews()
            self.activeViewController?.removeFromParent()
            self.segmentStackView.subviews.forEach({ ($0 as? SegmentButton)?.isSelected = false })
        }
        didSet {
            if self.activeSegment == nil {
                self.activeSegment = self.segments.first
            }
            
            if let segment = self.activeSegment {
                self.addChild(segment.viewController)
                
                self.containerView.addSubview(segment.viewController.view, { make in
                    make.edges.equalToSuperview()
                })
                
                segment.viewController.didMove(toParent: self)
                
                let button = self.segmentButton(for: segment)
                button.isSelected = true
            }
        }
    }
    
    public var activeViewController: UIViewController? {
        return self.activeSegment?.viewController
    }
    
    // MARK: - UI
    
    private var segmentButtons = [SegmentButton]() {
        didSet {
            self.segmentStackView.removeAllSubviews()
            self.segmentStackView.addArrangedSubviews(self.segmentButtons)
        }
    }
    
    private lazy var segmentStackView: UIStackView = {
        let view = UIStackView(
            axis: .horizontal,
            alignment: .fill,
            distribution: .fillEqually
        )
        
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView.color(self.segmentSeparatorColor, withHeight: 1)
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(
            axis: .vertical,
            alignment: .fill,
            distribution: .fill,
            insetsLayoutMarginsFromSafeArea: true,
            subviews: [
                self.segmentStackView,
                self.separatorView,
                self.containerView,
            ]
        )
        
        return view
    }()
    
    // MARK: - Init
    
    public init(
        backgroundColor: UIColor = .white,
        inactiveSegmentTitleStyle: UILabel.Style,
        activeSegmentTitleStyle: UILabel.Style,
        segmentBadgeTextStyle: UILabel.Style,
        segmentBadgeColor: UIColor,
        segmentSeparatorColor: UIColor,
        segments: [Segment] = []
    ) {
        self.backgroundColor = backgroundColor
        self.inactiveSegmentTitleStyle = inactiveSegmentTitleStyle
        self.activeSegmentTitleStyle = activeSegmentTitleStyle
        self.segmentBadgeTextStyle = segmentBadgeTextStyle
        self.segmentBadgeColor = segmentBadgeColor
        self.segmentSeparatorColor = segmentSeparatorColor
        self.segments = segments
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.backgroundColor
        
        self.view.addSubview(self.stackView, { make in
            make.edges.equalToSuperview()
        })
        
        self.segments = nil ?? self.segments
    }
    
    // MARK: - Methods
    
    private func segmentButton(for segment: Segment) -> SegmentButton {
        if let button = self.segmentButtons.first(where: { $0.segmentId == segment.id }) {
            return button
        } else {
            return SegmentButton(
                segmentId: segment.id,
                viewModel: .init(
                    title: segment.title,
                    inactiveTitleStyle: self.inactiveSegmentTitleStyle,
                    activeTitleStyle: self.activeSegmentTitleStyle,
                    badgeText: segment.badgeText,
                    badgeTextStyle: self.segmentBadgeTextStyle,
                    badgeColor: self.segmentBadgeColor,
                    action: { [weak self] in
                        self?.activeSegment = segment
                    }
                )
            )
        }
    }
    
    public func setBadgeText(_ text: String?, for segment: Segment) {
        if let index = self.segments.firstIndex(where: { $0.id == segment.id }) {
            self.segments[index].badgeText = text
        }
        
        self.segmentButton(for: segment).viewModel.badgeText = text
    }
    
}
