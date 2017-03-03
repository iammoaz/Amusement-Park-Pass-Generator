//
//  CreatePassController.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/20/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import UIKit

class CreatePassController: UIViewController {
    
    @IBOutlet weak var entrantTypeStackView: UIStackView!
    @IBOutlet weak var entrantSubTypeStackView: UIStackView!
    @IBOutlet weak var generatePassButton: UIButton!
    @IBOutlet weak var populateDataButton: UIButton!
    @IBOutlet weak var inputStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var inputViews: [UIStackView]! {
        didSet {
            inputSubViews = inputViews.flatMap { $0.arrangedSubviews }
            toggle(views: inputSubViews, on: false)
            
            for case let textField as UITextField in inputSubViews {
                textField.delegate = self
            }
        }
    }
    
    @IBOutlet var inputFields: [UITextField]! {
        didSet {
            for inputField in inputFields {
                inputField.delegate = self
            }
        }
    }
    
    var activeInputFields: [InputField : UITextField] = [:]
    var activeInputField: UITextField?
    
    var selectedEntrantType: EntrantType = .Guest
    var selectedSubType: SubType = GuestType.classic.subType
    
    var entrantPass: Passable? = nil
    var inputSubViews: [UIView] = []
    
    var entrantName: EntrantName?
    var entrantDateOfBirth: EntrantBirthdate?
    var entrantDateOfVisit: EntrantVisitDate?
    var entrantAddress: EntrantAddress?
    var entrantSocialSecurityNumber: EntrantSocialSecurityNumber?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubTypes(forType: .Guest)
        let guestButton = entrantTypeStackView.subviews.first as! UIButton
        let classicButton = entrantSubTypeStackView.subviews.first as! UIButton
        
        setColorsForButtons(inStack: entrantTypeStackView, selectedButton: guestButton)
        setColorsForButtons(inStack: entrantSubTypeStackView, selectedButton: classicButton)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        guard let dictionary = notification.userInfo, let keyboardFrameValue = dictionary[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let inputFieldsToMove = [activeInputFields[.streetAddress], activeInputFields[.city], activeInputFields[.state], activeInputFields[.zipCode]]
        
        if inputFieldsToMove.contains(where: { (textField) -> Bool in textField == activeInputField }) {
            UIView.animate(withDuration: 0.8) {
                self.inputStackViewTopConstraint.constant = 100 - keyboardFrame.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.8) {
            self.inputStackViewTopConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    func toggle(views: [UIView], on value: Bool) {
        if value {
            for case let label as UILabel in views {
                label.textColor = Theme.accentColor
            }
            
            for case let textField as UITextField in views {
                textField.isEnabled = value
                activeInputFields.updateValue(textField, forKey: InputField(rawValue: textField.tag)!)
            }
            
        } else {
            for case let label as UILabel in views {
                label.textColor = Theme.disableColor
            }
            
            for case let textField as UITextField in views {
                textField.text = ""
                textField.isEnabled = value
            }
        }
    }
    
    
    func toggle(buttons: [UIButton], on value: Bool) {
        for button in buttons {
            button.isEnabled = value
            
            if value {
                button.alpha = 1.0
            } else {
                button.alpha = 0.5
            }
        }
    }
    
    func setSubTypes(forType type: EntrantType) {
        let _ = entrantSubTypeStackView.arrangedSubviews.map {
            entrantSubTypeStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        var titles: [String] = []
        
        switch type {
            case .Guest:
                titles = GuestType.allTypes
            case .Employee:
                titles = EmployeeType.allTypes
            case .Manager:
                titles = ManagerType.allTypes
            case .Vendor:
                titles = VendorType.allTypes
            case .Contractor:
                titles = ContractorType.allTypes
        }
        
        addSubTypeButtons(withTitles: titles)
    }
    
    func addSubTypeButtons(withTitles titles: [String]) {
        for title in titles {
            let button = Theme.createButton(title: title)
            entrantSubTypeStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(CreatePassController.enableFieldsForSubType(_:)), for: .touchUpInside)
        }
        
        let firstSubType = entrantSubTypeStackView.subviews.first as! UIButton
        enableFieldsForSubType(firstSubType)
    }
    
    func setColorsForButtons(inStack stackview: UIStackView, selectedButton: UIButton) {
        _ = stackview.arrangedSubviews.map { view in
            if let button = view as? UIButton {
                button.setTitleColor(button == selectedButton ? .white : Theme.fadeButtonColor, for: .normal)
            }
        }
    }
    
    func enableFieldsForSubType(_ sender: UIButton) {
        // update the property for selected subtype
        selectedSubType = sender.currentTitle!
        let tags: [Tag]
        // get the required fields depending on the selected entrant and subtype
        switch selectedEntrantType {
            case .Guest:
                tags = GuestType.requiredInputFields(forSubType: selectedSubType).map { $0.rawValue }
            case .Employee:
                tags = EmployeeType.requiredInputFields(forSubType: selectedSubType).map { $0.rawValue }
            case .Manager:
                tags = ManagerType.requiredInputFields(forSubType: selectedSubType).map { $0.rawValue }
            case .Vendor:
                tags = VendorType.requiredInputFields(forSubType: selectedSubType).map { $0.rawValue }
            case .Contractor:
                tags = ContractorType.requiredInputFields(forSubType: selectedSubType).map { $0.rawValue }
        }
        
        UIView.animate(withDuration: 0.5) {
            self.setColorsForButtons(inStack: self.entrantSubTypeStackView, selectedButton: sender)
            self.enableTextFields(withTags: tags)
        }
    }
    
    func enableTextFields(withTags tags: [Tag]) {
        disableTextFields()
        
        let views = (inputSubViews.filter { tags.contains($0.tag) }).map { $0 }
        toggle(views: views, on: true)
    }
    
    func disableTextFields() {
        toggle(views: inputSubViews, on: false)
        activeInputFields = [:]
    }
    
    func getDataFromInputFields() {
        let fields = activeInputFields.map { $0.value }
        
        if let firstName = fields.filter({ $0.tag == 100 }).map({ $0.text }).first, let lastName = fields.filter({ $0.tag == 101 }).map({ $0.text }).first {
            
            if let firstName = firstName, let lastName = lastName {
                self.entrantName = EntrantName(firstName: firstName, lastName: lastName)
            } else {
                Theme.displayAlert(title: "Invalid Entry", message: "Name fields cannot be empty", viewController: self)
            }
        }
        
        if let dateOfBirth = fields.filter({ $0.tag == 102 }).map({ $0.text }).first {
            if let dateOfBirth = dateOfBirth {
                guard (Date.getDateFromString(stringDate: dateOfBirth) != nil) else {
                    Theme.displayAlert(title: "Invalid Entry", message: "The date format seems to be invalid. Please enter date in MM/DD/YYYY format.", viewController: self)
                    return
                }
                
                self.entrantDateOfBirth = EntrantBirthdate(dateOfBirth: dateOfBirth)
            }
        }
        
        if let socialSecurityNumber = fields.filter({ $0.tag == 103 }).map({ $0.text }).first {
            self.entrantSocialSecurityNumber = EntrantSocialSecurityNumber(socialSecurityNumber: socialSecurityNumber)
        }
        
        if let companyName = fields.filter({ $0.tag == 104 }).map({ $0.text }).first {
            if companyName != selectedSubType {
                Theme.displayAlert(title: "Invalid Entry", message: "The compnay does not match with the selected type", viewController: self)
            }
        }
        
        if let projectNumber = fields.filter({ $0.tag == 105 }).map({ $0.text }).first {
            if projectNumber != selectedSubType {
                Theme.displayAlert(title: "Invalid Entry", message: "The project number does not match with the selected type", viewController: self)
            }
        }
        
        if let dateOfVisit = fields.filter({ $0.tag == 106 }).map({ $0.text }).first {
            if let dateOfVisit = dateOfVisit {
                guard (Date.getDateFromString(stringDate: dateOfVisit) != nil) else {
                    Theme.displayAlert(title: "Invalid Entry", message: "The date format seems to be invalid. Please enter date in MM/DD/YYYY format.", viewController: self)
                    return
                }
                
                
                self.entrantDateOfVisit = EntrantVisitDate(dateOfVisit: dateOfVisit)
            }
        }
        
        if let street = fields.filter({ $0.tag == 107 }).map({ $0.text }).first, let city = fields.filter({ $0.tag == 108 }).map({ $0.text }).first, let state = fields.filter({ $0.tag == 109 }).map({ $0.text }).first, let zipCode = fields.filter({ $0.tag == 110 }).map({ $0.text }).first {
            self.entrantAddress = EntrantAddress(street: street, city: city, state: state, zipCode: zipCode)
        }
        
        createEntrantPass()
    }
    
    func createEntrantPass() {
        switch selectedEntrantType {
        case .Guest:
            let pass = GuestType.createPass(for: selectedSubType, name: self.entrantName, address: self.entrantAddress, birthdate: self.entrantDateOfBirth)
            self.entrantPass = pass
        case .Employee:
            let pass = EmployeeType.createPass(for: selectedSubType, name: self.entrantName, address: self.entrantAddress, birthdate: self.entrantDateOfBirth, socialSecurityNumber: self.entrantSocialSecurityNumber)
            self.entrantPass = pass
        case .Manager:
            let pass = ManagerType.createPass(for: selectedSubType, name: self.entrantName, address: self.entrantAddress, birthdate: self.entrantDateOfBirth, socialSecurityNumber: self.entrantSocialSecurityNumber)
            self.entrantPass = pass
        case .Vendor:
            let pass = VendorType.createPass(for: selectedSubType, name: self.entrantName, birthdate: self.entrantDateOfBirth, visitdate: self.entrantDateOfVisit)
            self.entrantPass = pass
        case .Contractor:
            let pass = ContractorType.createPass(for: selectedSubType, name: self.entrantName, address: self.entrantAddress, birthdate: self.entrantDateOfBirth, socialSecurityNumber: self.entrantSocialSecurityNumber)
            self.entrantPass = pass
        }
        
        guard self.entrantPass != nil else { return }
        self.performSegue(withIdentifier: "TestPassController", sender: nil)
        
    }
    
    
    func populateData() {
        let fields = activeInputFields.map { $0.value }
        for field in fields {
            switch field.tag {
            case 100:
                field.text = Data.name.firstName
            case 101:
                field.text = Data.name.lastName
            case 102:
                field.text = Data.birthdate.dateOfBirth
            case 103:
                field.text = Data.socialSecurityNumber.socialSecurityNumber
            case 104:
                field.text = selectedSubType
            case 105:
                field.text = selectedSubType
            case 106:
                field.text = Data.visidate.dateOfVisit
            case 107:
                field.text = Data.address.street
            case 108:
                field.text = Data.address.city
            case 109:
                field.text = Data.address.state
            case 110:
                field.text = Data.address.zipCode
            default:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TestPassController" {
            let controller = segue.destination as! TestPassController
            if let entrantPass = self.entrantPass {
                controller.pass = entrantPass
            }
        }
    }
    
    @IBAction func selectEntrantType(_ sender: UIButton) {
        setColorsForButtons(inStack: entrantTypeStackView, selectedButton: sender)
        disableTextFields()
        if let entrantType = EntrantType(rawValue: sender.currentTitle!) {
            selectedEntrantType = entrantType
            setSubTypes(forType: entrantType)
        }
    }
    
    @IBAction func generatePassTapped(_ sender: UIButton) {
        if (activeInputFields.filter({ $0.value.text == "" })).count >= 1 {
            Theme.displayAlert(title: "Invalid Input", message: "One or more input fields are empty", viewController: self)
        }
        getDataFromInputFields()
    }
    
    @IBAction func populateDataTapped(_ sender: UIButton) {
        populateData()
    }
}

extension CreatePassController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let currentTextField = (activeInputFields.filter { (key, value) in value == textField }).first {
            activeInputField = currentTextField.value
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
