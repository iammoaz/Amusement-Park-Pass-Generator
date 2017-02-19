//
//  ThemeButton.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/16/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import UIKit

@IBDesignable
class ThemeButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = 3.0
        self.layer.borderWidth = 2.0
        self.layer.borderColor = Theme.buttonBorderColor.cgColor
    }

}
