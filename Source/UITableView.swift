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

public typealias UITableViewDelegateDataSource = UITableViewDelegate & UITableViewDataSource

extension UITableView {
    
    /// If `dataSource` is `nil`, and `delegate` is also a `UITableViewDataSource` it will be set as the view's `dataSource` ,
    public convenience init(
        delegate: UITableViewDelegate? = nil,
        dataSource: UITableViewDataSource? = nil,
        style: UITableView.Style = .plain,
        estimatedRowHeight: CGFloat = 44,
        separatorStyle: UITableViewCell.SeparatorStyle = .none,
        separatorColor: UIColor = .clear,
        separatorInset: UIEdgeInsets = .zero,
        headerView: UIView? = nil,
        footerView: UIView? = nil
    ) {
        self.init(frame: .zero, style: style)
        self.delegate = delegate
        self.dataSource = dataSource ?? delegate as? UITableViewDataSource
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = estimatedRowHeight
        self.separatorStyle = separatorStyle
        self.separatorColor = separatorColor
        self.separatorInset = separatorInset
        
        if #available(iOS 15, *) {
            self.sectionHeaderTopPadding = 0
        }
        
        if separatorStyle == .none {
            // ipadOS doesn't use .none properly
            self.separatorColor = .clear
        }
        
        if let headerView = headerView {
            self.setHeaderView(headerView)
        }
        
        if let footerView = footerView {
            self.setFooterView(footerView)
        } else {
            // Always having a footer removes the ugly infinite cell separators that would show after the last cell in the table view
            self.tableFooterView = UIView()
        }
    }
    
    public func setHeaderView(_ headerView: UIView?) {
        guard let headerView = headerView else {
            self.tableHeaderView = nil
            return
        }
        
        // Set the initial height to the autolayout computed height to prevent layout warnings.
        let wrapperView = TableHeaderView(frame: .init(x: 0, y: 0, width: 0, height: headerView.systemLayoutSizeFitting(
            CGSize(width: self.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: UILayoutPriority.defaultLow
        ).height))
        
        wrapperView.addSubview(headerView, { make in
            make.edges.equalToSuperview()
        })
        
        self.tableHeaderView = wrapperView
    }
    
    public func setFooterView(_ footerView: UIView?) {
        guard let footerView = footerView else {
            self.tableFooterView = nil
            return
        }
        
        // Set the initial height to the autolayout computed height to prevent layout warnings.
        let wrapperView = TableFooterView(frame: .init(x: 0, y: 0, width: 0, height: footerView.systemLayoutSizeFitting(
            CGSize(width: self.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: UILayoutPriority.defaultLow
        ).height))
        
        wrapperView.addSubview(footerView, { make in
            make.edges.equalToSuperview()
        })
        
        self.tableFooterView = wrapperView
    }
    
    public func dequeueCell<CellType: UITableViewCell>(for indexPath: IndexPath) -> CellType {
        self.register(CellType.self, forCellReuseIdentifier: String(describing: CellType.self))
        
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: CellType.self), for: indexPath) as? CellType else {
            fatalError("Unable to dequeue reusable cell of type `\(CellType.self)`.")
        }
        
        return cell
    }
    
    public func scrollToBottom(animated: Bool) {
        guard self.numberOfSections > 0 else { return }
        
        var section = self.numberOfSections - 1
        var row = self.numberOfRows(inSection: section) - 1
        
        while row < 0 {
            guard section > 0 else { return }
            section -= 1
            row = self.numberOfRows(inSection: section) - 1
        }
        
        let indexPath = IndexPath(row: row, section: section)
        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        
        DispatchQueue.main.async(execute: {
            // The code above doesn't account for the footer view,
            // but the code below doesn't always work on its own (possibly because of reloads interupting it?),
            // so we combine both to get the desired result.
            let bottom = CGRect(x: 0, y: self.contentSize.height-1, width: 1, height: 1)
            self.scrollRectToVisible(bottom, animated: animated)
        })
    }
    
}

fileprivate final class TableHeaderView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.systemLayoutSizeFitting(
            CGSize(width: self.superview?.frame.width ?? 0, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: UILayoutPriority.defaultLow
        ).height
        
        self.frame.size.height = height
        
        if let tableView = self.superview as? UITableView {
            tableView.tableHeaderView = self
        }
    }
    
}

fileprivate final class TableFooterView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.systemLayoutSizeFitting(
            CGSize(width: self.superview?.frame.width ?? 0, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: UILayoutPriority.defaultLow
        ).height
        
        self.frame.size.height = height
        
        if let tableView = self.superview as? UITableView {
            tableView.tableFooterView = self
        }
    }
    
}
