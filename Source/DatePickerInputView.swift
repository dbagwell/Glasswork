//
//  DatePickerInputView.swift
//  Glasswork
//
//  Created by David Bagwell on 2020-07-30.
//  Copyright © 2020 David Bagwell. All rights reserved.
//

import UIKit

public final class DatePickerInputView: UIView {
    
    // MARK: - Properties
    
    private weak var responder: UIResponder?
    private let selectButtonAction: (Date) -> Void
    
    
    // MARK: - UI
    
    private lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.backgroundColor = .white
        
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        
        return view
    }()
    
    private lazy var selectButton: UIBarButtonItem = {
        let view = UIBarButtonItem(
            title: "Select",
            style: .done,
            target: self,
            action: #selector(self.selectButtonPressed)
        )
        
        return view
    }()
    
    private lazy var toolbar: UIToolbar = {
        let view = UIToolbar()
        view.isTranslucent = false
        view.barTintColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        view.setContentHuggingPriority(.required, for: .vertical)
        view.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            self.selectButton,
        ]
        
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
        self.selectButton.tintColor = selectButtonColor
        
        self.addSubview(self.toolbar, { make in
            make.top.left.right.equalToSuperview()
        })
        
        self.addSubview(self.datePicker, { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(self.toolbar.snp.bottom)
        })
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    
    @objc private func selectButtonPressed() {
        self.selectButtonAction(self.datePicker.date)
        self.responder?.resignFirstResponder()
    }
    
}
