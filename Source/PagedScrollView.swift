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

import SnapKit
import UIKit

public final class PagedScrollView: UIView, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    private let itemWidth: CGFloat
    private let itemSpacing: CGFloat
    private let itemsInsets: UIEdgeInsets
    private let shouldShowItemIndicator: Bool
    
    private var numberOfItems: Int {
        return self.itemStackView.arrangedSubviews.count
    }
    
    private var currentItemIndex = 0 {
        didSet {
            self.itemIndicator.currentPage = self.currentItemIndex
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            self.itemIndicator.currentPageIndicatorTintColor = self.tintColor
            self.itemIndicator.pageIndicatorTintColor = self.tintColor.withAlphaComponent(0.3)
        }
    }
    
    // MARK: - UI
    
    private lazy var itemStackView: UIStackView = {
        let view = UIStackView(
            axis: .horizontal,
            alignment: .fill,
            distribution: .fill,
            spacing: self.itemSpacing,
            layoutMargins: self.itemsInsets,
            subviews: []
        )
        
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        
        view.addSubview(self.itemStackView, { make in
            make.edges.height.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().priority(.low)
        })
        
        return view
    }()
    
    private lazy var itemIndicator: UIPageControl = {
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = self.tintColor
        view.pageIndicatorTintColor = self.tintColor.withAlphaComponent(0.3)
        view.addAction(for: .valueChanged, action: { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.25, animations: {
                if self.itemIndicator.currentPage == self.numberOfItems - 1 {
                    self.scrollView.contentOffset.x = max(self.scrollView.contentSize.width - self.scrollView.frame.width, 0)
                } else {
                    self.scrollView.contentOffset.x = (self.itemWidth + self.itemSpacing) * CGFloat(self.itemIndicator.currentPage)
                }
            })
        })
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(
            axis: .vertical,
            alignment: .fill,
            distribution: .fill,
            subviews: [
                self.scrollView,
                self.shouldShowItemIndicator ? self.itemIndicator : nil,
            ].compact()
        )
        
        return view
    }()
    
    // MARK: - Init
    
    public init(
        itemWidth: CGFloat,
        itemSpacing: CGFloat,
        itemsInsets: UIEdgeInsets,
        shouldShowItemIndicator: Bool
    ) {
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        self.itemsInsets = itemsInsets
        self.shouldShowItemIndicator = shouldShowItemIndicator
        
        super.init(frame: .zero)
        
        self.addSubview(self.stackView, { make in
            make.edges.equalToSuperview()
        })
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func addItemView(_ view: UIView) {
        self.itemStackView.addArrangedSubview(view)
        self.itemIndicator.numberOfPages += 1
        
        view.snp.updateConstraints({ make in
            make.width.equalTo(self.itemWidth)
        })
    }
    
    public func setItemViews(_ views: [UIView]) {
        self.itemStackView.removeAllSubviews()
        self.itemIndicator.numberOfPages = 0
        views.forEach({ self.addItemView($0) })
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.frame.width {
            self.currentItemIndex = self.numberOfItems
        } else {
            self.currentItemIndex = Int(scrollView.contentOffset.x) / Int(self.itemWidth + self.itemSpacing)
        }
    }
    
    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let singleItemOffset = self.itemWidth + self.itemSpacing
        var targetItemIndex = self.currentItemIndex
        
        if velocity.x > 0 {
            targetItemIndex += 1
        } else if velocity.x < 0 {
            targetItemIndex -= 1
        } else {
            targetItemIndex = (Int(targetContentOffset.pointee.x - singleItemOffset / 2) / Int(singleItemOffset)) + 1
        }
        
        if targetItemIndex < 0 {
            targetItemIndex = 0
        } else if targetItemIndex > self.numberOfItems - 1 {
            targetItemIndex = self.numberOfItems - 1
        }
        
        targetContentOffset.pointee.x = (self.itemWidth + self.itemSpacing) * CGFloat(targetItemIndex)
    }
    
}
