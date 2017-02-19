//
//  ThemeInputView.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/19/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import UIKit

@IBDesignable
class ThemeInputView: UIView {

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
        self.layer.backgroundColor = UIColor.white.cgColor
    }

}
