//
//  AmusementParkPassGeneratorTests.swift
//  AmusementParkPassGeneratorTests
//
//  Created by Muhammad Moaz on 2/11/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import XCTest

class AmusementParkPassGeneratorTests: XCTestCase {
    
    let passGenerator = AccessPassGenerator.instance
    let passReader = PassReader.instance
    let entrantDetails = EntrantDetails(firstName: "Muhammad", lastName: "Moaz", streetAddress: "86", city: "Khaitan", state: "FL", zipCode: "83001")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Classic Guest
    func testClassicGuestType() {
        let guestPass = passGenerator.createPass(forEntrant: GuestType.classic)
        XCTAssertTrue(guestPass.hasAccess(toArea: .amusement))
        XCTAssertFalse(guestPass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(guestPass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(guestPass.hasAccess(toArea: .office))
        XCTAssertFalse(guestPass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(guestPass.allRideAccess)
        XCTAssertFalse(guestPass.skipsQueues)
        XCTAssertEqual(guestPass.foodDiscount, 0)
        XCTAssertEqual(guestPass.merchandiseDiscount, 0)
    }
    
    // Vip Guest
    func testVipGuestType() {
        let vipPass = passGenerator.createPass(forEntrant: GuestType.vip)
        XCTAssertTrue(vipPass.hasAccess(toArea: .amusement))
        XCTAssertFalse(vipPass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(vipPass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(vipPass.hasAccess(toArea: .office))
        XCTAssertFalse(vipPass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(vipPass.allRideAccess)
        XCTAssertTrue(vipPass.skipsQueues)
        XCTAssertEqual(vipPass.foodDiscount, 10)
        XCTAssertEqual(vipPass.merchandiseDiscount, 20)
        XCTAssertNil(vipPass.contactInfo)
    }
    
    // Child Guest
    func testChildGuestType() {
        // Date Format: yyyy-mm-dd
        let birthday = "2012-11-29"
        let childPass = passGenerator.createPass(forEntrant: GuestType.child(birthdate: birthday))
        XCTAssertTrue(childPass.hasAccess(toArea: .amusement))
        XCTAssertFalse(childPass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(childPass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(childPass.hasAccess(toArea: .office))
        XCTAssertFalse(childPass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(childPass.allRideAccess)
        XCTAssertFalse(childPass.skipsQueues)
        XCTAssertEqual(childPass.foodDiscount, 0)
        XCTAssertEqual(childPass.merchandiseDiscount, 0)
        XCTAssertNil(childPass.contactInfo)
        XCTAssertTrue(try! childPass.birthdate(dateString: birthday, meetsRequirement: 5))
    }
    
    // Food Services
    func testFoodServicesEmployeeType() {
        let employeePass = passGenerator.createPass(forEntrant: EmployeeType.foodServices(entrantDetails))
        XCTAssertTrue(employeePass.hasAccess(toArea: .amusement))
        XCTAssertTrue(employeePass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(employeePass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(employeePass.hasAccess(toArea: .office))
        XCTAssertFalse(employeePass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(employeePass.allRideAccess)
        XCTAssertTrue(employeePass.skipsQueues)
        XCTAssertEqual(employeePass.foodDiscount, 15)
        XCTAssertEqual(employeePass.merchandiseDiscount, 25)
        XCTAssertNotNil(employeePass.contactInfo)
    }
    
    // Ride Services
    func testRideServicesEmployeeType() {
        let employeePass = passGenerator.createPass(forEntrant: EmployeeType.rideServices(entrantDetails))
        XCTAssertTrue(employeePass.hasAccess(toArea: .amusement))
        XCTAssertFalse(employeePass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(employeePass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(employeePass.hasAccess(toArea: .office))
        XCTAssertTrue(employeePass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(employeePass.allRideAccess)
        XCTAssertTrue(employeePass.skipsQueues)
        XCTAssertEqual(employeePass.foodDiscount, 15)
        XCTAssertEqual(employeePass.merchandiseDiscount, 25)
        XCTAssertNotNil(employeePass.contactInfo)
    }
    
    // Maintenance Employee
    func testMaintenanceEmployeeType() {
        let employeePass = passGenerator.createPass(forEntrant: EmployeeType.maintenance(entrantDetails))
        XCTAssertTrue(employeePass.hasAccess(toArea: .amusement))
        XCTAssertTrue(employeePass.hasAccess(toArea: .kitchen))
        XCTAssertTrue(employeePass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(employeePass.hasAccess(toArea: .office))
        XCTAssertTrue(employeePass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(employeePass.allRideAccess)
        XCTAssertTrue(employeePass.skipsQueues)
        XCTAssertEqual(employeePass.foodDiscount, 15)
        XCTAssertEqual(employeePass.merchandiseDiscount, 25)
        XCTAssertNotNil(employeePass.contactInfo)
    }
    
    // Manager
    func testManagerType() {
        let managerPass = passGenerator.createPass(forEntrant: ManagerType.manager(entrantDetails))
        XCTAssertTrue(managerPass.hasAccess(toArea: .amusement))
        XCTAssertTrue(managerPass.hasAccess(toArea: .kitchen))
        XCTAssertTrue(managerPass.hasAccess(toArea: .maintenance))
        XCTAssertTrue(managerPass.hasAccess(toArea: .office))
        XCTAssertTrue(managerPass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(managerPass.allRideAccess)
        XCTAssertTrue(managerPass.skipsQueues)
        XCTAssertEqual(managerPass.foodDiscount, 25)
        XCTAssertEqual(managerPass.merchandiseDiscount, 25)
        XCTAssertNotNil(managerPass.contactInfo)
    }
    
    // Sound
    func testSound() {
        XCTAssertNotNil(passReader.playSound(true))
        XCTAssertNotNil(passReader.playSound(false))
    }
}
