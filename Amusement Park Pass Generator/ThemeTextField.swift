//
//  ThemeTextField.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/19/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import UIKit

@IBDesignable
class ThemeTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = 5.0
        self.layer.backgroundColor = Theme.textFieldBackgroundColor.cgColor
        
        self.tintColor = Theme.accentColor
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
}
