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

class SegmentButton: UIControl {
    
    struct ViewModel {
        
        let title: String
        let inactiveTitleStyle: UILabel.Style
        let activeTitleStyle: UILabel.Style
        var badgeText: String?
        let badgeTextStyle: UILabel.Style
        let badgeColor: UIColor
        let action: () -> Void
        
    }
    
    // MARK: - Properties
    
    let segmentId: UUID
    
    var viewModel: ViewModel {
        didSet {
            self.update()
        }
    }
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    private lazy var badgeLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    private lazy var badgeView: UIView = {
        let view = UIView()
        view.setBorder(radius: 7.5)
        view.snp.makeConstraints({ make in
            make.height.equalTo(15)
            make.width.greaterThanOrEqualTo(15)
        })
        
        view.addSubview(self.badgeLabel, { make in
            make.edges.equalToSuperview()
        })
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(
            axis: .horizontal,
            alignment: .center,
            distribution: .fill,
            spacing: 5,
            layoutMargins: UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5),
            subviews: [
                UIView(),
                self.titleLabel,
                self.badgeView,
                UIView(),
            ]
        )
        
        view.isUserInteractionEnabled = false
        
        self.titleLabel.snp.makeConstraints({ make in
            make.centerX.equalToSuperview().priority(.high)
        })
        
        return view
    }()
    
    // MARK: - Init
    
    init(segmentId: UUID, viewModel: ViewModel) {
        self.segmentId = segmentId
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        self.addAction(action: { [weak self] in
            self?.viewModel.action()
        })
        
        self.addSubview(self.stackView, { make in
            make.edges.equalToSuperview()
        })
        
        self.update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIControl
    
    override var primaryAction: UIControl.Event {
        return .touchUpInside
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: self.isHighlighted ? 0 : 0.25, animations: {
                self.alpha = self.isHighlighted ? 0.2 : 1
            })
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.update()
        }
    }
    
    // MARK: - Methods
    
    private func update() {
        self.titleLabel.text = self.viewModel.title
        self.titleLabel.set(self.isSelected ? self.viewModel.activeTitleStyle : self.viewModel.inactiveTitleStyle)
        self.badgeView.isHidden = self.viewModel.badgeText == nil
        self.badgeLabel.text = self.viewModel.badgeText
        self.badgeLabel.set(self.viewModel.badgeTextStyle)
        self.badgeView.backgroundColor = self.viewModel.badgeColor
    }
    
}
