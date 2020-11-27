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

public final class DatePickerInputView: UIView {
    
    // MARK: - Properties
    
    private weak var responder: UIResponder?
    private let selectButtonAction: (Date) -> Void
    
    
    // MARK: - UI
    
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        
        return view
    }()
    
    
    // MARK: - Init
    
    public init(
        mode: UIDatePicker.Mode,
        date: Date,
        calendar: Calendar = Calendar(identifier: .gregorian),
        responder: UIResponder,
        selectButtonColor: UIColor,
        selectButtonAction: @escaping (Date) -> Void
    ) {
        self.responder = responder
        self.selectButtonAction = selectButtonAction
        
        super.init(frame: .zero)
        
        self.frame.size.height = 275
        self.datePicker.datePickerMode = mode
        self.datePicker.date = date
        self.datePicker.calendar = calendar
        
        let toolbar = UIToolbar(
            rightButtonTitle: "Select",
            tintColor: selectButtonColor,
            action: {
                self.selectButtonAction(self.datePicker.date)
                self.responder?.resignFirstResponder()
            }
        )
        
        self.addSubview(toolbar, { make in
            make.top.left.right.equalToSuperview()
        })
        
        self.addSubview(self.datePicker, { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(toolbar.snp.bottom)
        })
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
