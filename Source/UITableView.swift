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
    
    public func setHeaderView(_ headerView: UIView) {
        let view = TableHeaderView()
        view.addSubview(headerView, { make in
            make.edges.equalToSuperview()
        })
        
        self.tableHeaderView = view
    }
    
    public func setFooterView(_ footerView: UIView) {
        let view = TableFooterView()
        view.addSubview(footerView, { make in
            make.edges.equalToSuperview()
        })
        
        self.tableFooterView = view
    }
    
    public func dequeueCell<CellType: UITableViewCell>(for indexPath: IndexPath) -> CellType {
        self.register(CellType.self, forCellReuseIdentifier: String(describing: CellType.self))
        
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: CellType.self), for: indexPath) as? CellType else {
            fatalError("Unable to dequeue reusable cell of type `\(CellType.self)`.")
        }
        
        return cell
    }
    
    public func scrollToBottom(animated: Bool) {
        let section = self.numberOfSections - 1
        let row = self.numberOfRows(inSection: section) - 1
        let indexPath = IndexPath(row: row, section: section)
        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
}

fileprivate final class TableHeaderView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.frame.size.height = height
        
        if let tableView = superview as? UITableView {
            tableView.tableHeaderView = self
        }
    }
    
}

fileprivate final class TableFooterView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.frame.size.height = height
        
        if let tableView = superview as? UITableView {
            tableView.tableFooterView = self
        }
    }
    
}
