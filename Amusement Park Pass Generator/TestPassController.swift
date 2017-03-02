//
//  TestPassController.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/20/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import UIKit

class TestPassController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passTypeLabel: UILabel!
    @IBOutlet weak var rideAccessLabel: UILabel!
    @IBOutlet weak var queueAccessLabel: UILabel!
    @IBOutlet weak var foodDiscountLabel: UILabel!
    @IBOutlet weak var merchDiscountLabel: UILabel!
    
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    var passReader = PassReader.instance
    var pass: Passable? = nil
    weak var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let pass = pass else { return }
        configureViewFor(pass)
    }
    
    func configureViewFor(_ pass: Passable) {
        if let name = pass.entrant.name {
            nameLabel.text = "\(name.firstName!) \(name.lastName!)"
        } else {
            nameLabel.text = "Guest"
        }
        
        let type = pass.entrant.subType
            passTypeLabel.text = "\(type.capitalized) Pass"
        
        let rideAccess = pass.entrant.rideAccess
        
        if rideAccess.allRides {
            rideAccessLabel.text = "Access to all rides"
        } else {
            rideAccessLabel.isHidden = true
        }
        
        if rideAccess.skipsQueues {
            queueAccessLabel.text = "Can skip queues"
        } else {
            queueAccessLabel.isHidden = true
        }
        
        let food = pass.entrant.discounts.food
        foodDiscountLabel.text = "Food Discount - \(food)%"
        
        let merch = pass.entrant.discounts.merchandise
        merchDiscountLabel.text = "Merchandise Discount - \(merch)%"
    }
    
    func testAccess(for pass: Passable, with tag: Tag) -> (Bool, message: AccessMessage) {
        switch tag {
        case 101:
            return passReader.swipeAccessFor(pass, hasAccessTo: .amusement)
        case 102:
            return passReader.swipeAccessFor(pass, hasAccessTo: .kitchen)
        case 103:
            return passReader.swipeAccessFor(pass, hasAccessTo: .rideControl)
        case 104:
            return passReader.swipeAccessFor(pass, hasAccessTo: .maintenance)
        case 105:
            return passReader.swipeAccessFor(pass, hasAccessTo: .office)
        case 201:
            return passReader.swipeAccessFor(pass, hasRideAccess: .all(true))
        case 202:
            return passReader.swipeAccessFor(pass, hasRideAccess: .skipsQueues(true))
        case 301:
            let discount = pass.entrant.discounts.food
            return passReader.swipeAccessFor(pass, discountFor: .food(discount))
        case 302:
            let discount = pass.entrant.discounts.merchandise
            return passReader.swipeAccessFor(pass, discountFor: .merchandise(discount))
        default:
            return (false, "Access Denied")
        }
    }
    
    func presentFeedback(success: Bool, message: AccessMessage) {
        startTimer ()
        feedbackView.backgroundColor = success ? Theme.accessGrantedColor : Theme.accessDeniedColor
        feedbackLabel.text = message
    }
    
    func startTimer () {
        stopTimer()
        timer =  Timer.scheduledTimer(timeInterval:TimeInterval(3), target:self, selector: #selector(self.dismissFeedback),
            userInfo: nil, repeats: true)
    }
    
    func dismissFeedback() {
        stopTimer()
        feedbackView.backgroundColor = .white
        feedbackLabel.text = "Test Access"
    }
    
    func stopTimer() {
        guard let timer = timer else { return }
        timer.invalidate()
        self.timer = nil
    }
    
    @IBAction func testAccess(_ sender: UIButton) {
        if let pass = pass {
            let result = testAccess(for: pass, with: sender.tag)
            presentFeedback(success: result.0, message: result.message)
        }
    }
    
    
    @IBAction func generateNewPass(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
