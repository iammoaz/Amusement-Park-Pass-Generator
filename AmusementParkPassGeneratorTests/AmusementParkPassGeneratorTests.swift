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
    let entrantName = EntrantName(firstName: "Muhammad", lastName: "Moaz")
    let entrantAddress = EntrantAddress(streetAddress: "86", city: "Khaitan", state: "FL", zipCode: "83001")
    let entrantBirthdate = EntrantBirthdate(dateOfBirth: "29-11-1991")
    let entrantVisitdate = EntrantVisitDate(dateOfVisit: "21-02-2017")
    let entrantSocialSecurityNumber = EntrantSocialSecurityNumber(socialSecurityNumber: "00000000000")
    
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
        let pass = passGenerator.createPass(forEntrant: GuestType.classic)
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertFalse(pass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(pass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(pass.hasAccess(toArea: .office))
        XCTAssertFalse(pass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(pass.allRideAccess)
        XCTAssertFalse(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 0)
        XCTAssertEqual(pass.merchandiseDiscount, 0)
    }
    
    // Vip Guest
    func testVipGuestType() {
        let pass = passGenerator.createPass(forEntrant: GuestType.vip)
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertFalse(pass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(pass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(pass.hasAccess(toArea: .office))
        XCTAssertFalse(pass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(pass.allRideAccess)
        XCTAssertTrue(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 10)
        XCTAssertEqual(pass.merchandiseDiscount, 20)
        XCTAssertNil(pass.address)
    }
    
    // Child Guest
    func testChildGuestType() {
        // Date Format: yyyy-mm-dd
        let birthdate = EntrantBirthdate(dateOfBirth: "2012-11-29")
        let childPass = passGenerator.createPass(forEntrant: GuestType.child(birthdate: birthdate))
        XCTAssertTrue(childPass.hasAccess(toArea: .amusement))
        XCTAssertFalse(childPass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(childPass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(childPass.hasAccess(toArea: .office))
        XCTAssertFalse(childPass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(childPass.allRideAccess)
        XCTAssertFalse(childPass.skipsQueues)
        XCTAssertEqual(childPass.foodDiscount, 0)
        XCTAssertEqual(childPass.merchandiseDiscount, 0)
        XCTAssertNil(childPass.address)
        XCTAssertTrue(try! childPass.birthdate(dateString: birthdate.dateOfBirth, meetsRequirement: 5))
    }
    
    // Food Services
    func testFoodServicesEmployeeType() {
        let pass = passGenerator.createPass(forEntrant: EmployeeType.foodServices(name: entrantName, address: entrantAddress, birthdate: entrantBirthdate, socialSecurityNumber: entrantSocialSecurityNumber))
        
        
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertTrue(pass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(pass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(pass.hasAccess(toArea: .office))
        XCTAssertFalse(pass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(pass.allRideAccess)
        XCTAssertTrue(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 15)
        XCTAssertEqual(pass.merchandiseDiscount, 25)
        XCTAssertNotNil(pass.address)
    }
    
    // Ride Services
    func testRideServicesEmployeeType() {
        let pass = passGenerator.createPass(forEntrant: EmployeeType.rideServices(name: entrantName, address: entrantAddress, birthdate: entrantBirthdate, socialSecurityNumber: entrantSocialSecurityNumber))
        
        
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertFalse(pass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(pass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(pass.hasAccess(toArea: .office))
        XCTAssertTrue(pass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(pass.allRideAccess)
        XCTAssertTrue(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 15)
        XCTAssertEqual(pass.merchandiseDiscount, 25)
        XCTAssertNotNil(pass.address)
    }
    
    // Maintenance Employee
    func testMaintenanceEmployeeType() {
        let pass = passGenerator.createPass(forEntrant: EmployeeType.maintenance(name: entrantName, address: entrantAddress, birthdate: entrantBirthdate, socialSecurityNumber: entrantSocialSecurityNumber))
        
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertTrue(pass.hasAccess(toArea: .kitchen))
        XCTAssertTrue(pass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(pass.hasAccess(toArea: .office))
        XCTAssertTrue(pass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(pass.allRideAccess)
        XCTAssertTrue(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 15)
        XCTAssertEqual(pass.merchandiseDiscount, 25)
        XCTAssertNotNil(pass.address)
    }
    
    // Manager
    func testManagerType() {
        let pass = passGenerator.createPass(forEntrant: ManagerType.manager(name: entrantName, address: entrantAddress, birthdate: entrantBirthdate, socialSecurityNumber: entrantSocialSecurityNumber))
        
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertTrue(pass.hasAccess(toArea: .kitchen))
        XCTAssertTrue(pass.hasAccess(toArea: .maintenance))
        XCTAssertTrue(pass.hasAccess(toArea: .office))
        XCTAssertTrue(pass.hasAccess(toArea: .rideControl))
        XCTAssertTrue(pass.allRideAccess)
        XCTAssertTrue(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 25)
        XCTAssertEqual(pass.merchandiseDiscount, 25)
        XCTAssertNotNil(pass.address)
    }
    
    // ACME Vendor
    func testACMEVendorType() {
        let pass = passGenerator.createPass(forEntrant: VendorType.acme(name: entrantName, birthdate: entrantBirthdate, visitdate: entrantVisitdate))
        XCTAssertFalse(pass.hasAccess(toArea: .amusement))
        XCTAssertTrue(pass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(pass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(pass.hasAccess(toArea: .office))
        XCTAssertFalse(pass.hasAccess(toArea: .rideControl))
        XCTAssertFalse(pass.allRideAccess)
        XCTAssertFalse(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 0)
        XCTAssertEqual(pass.merchandiseDiscount, 0)
    }
    
    // Fedex Vendor
    func testFedexVendorType() {
        let pass = passGenerator.createPass(forEntrant: VendorType.fedex(name: entrantName, birthdate: entrantBirthdate, visitdate: entrantVisitdate))
        XCTAssertFalse(pass.hasAccess(toArea: .amusement))
        XCTAssertFalse(pass.hasAccess(toArea: .kitchen))
        XCTAssertTrue(pass.hasAccess(toArea: .maintenance))
        XCTAssertTrue(pass.hasAccess(toArea: .office))
        XCTAssertFalse(pass.hasAccess(toArea: .rideControl))
        XCTAssertFalse(pass.allRideAccess)
        XCTAssertFalse(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 0)
        XCTAssertEqual(pass.merchandiseDiscount, 0)
    }
    
    // Orkin Vendor
    func testOrkinVendorType() {
        let pass = passGenerator.createPass(forEntrant: VendorType.orkin(name: entrantName, birthdate: entrantBirthdate, visitdate: entrantVisitdate))
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertTrue(pass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(pass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(pass.hasAccess(toArea: .office))
        XCTAssertTrue(pass.hasAccess(toArea: .rideControl))
        XCTAssertFalse(pass.allRideAccess)
        XCTAssertFalse(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 0)
        XCTAssertEqual(pass.merchandiseDiscount, 0)
    }
    
    // NWElectrical Vendor
    func testNWElectricalVendorType() {
        let pass = passGenerator.createPass(forEntrant: VendorType.nwElectrical(name: entrantName, birthdate: entrantBirthdate, visitdate: entrantVisitdate))
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertTrue(pass.hasAccess(toArea: .kitchen))
        XCTAssertTrue(pass.hasAccess(toArea: .maintenance))
        XCTAssertTrue(pass.hasAccess(toArea: .office))
        XCTAssertTrue(pass.hasAccess(toArea: .rideControl))
        XCTAssertFalse(pass.allRideAccess)
        XCTAssertFalse(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 0)
        XCTAssertEqual(pass.merchandiseDiscount, 0)
    }
    
    // Contractor
    func test1001ContractorType() {
        let pass = passGenerator.createPass(forEntrant: ContractorType.oneZeroZeroOne(name: entrantName, address: entrantAddress, birthdate: entrantBirthdate, socialSecurityNumber: entrantSocialSecurityNumber))
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertTrue(pass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(pass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(pass.hasAccess(toArea: .office))
        XCTAssertTrue(pass.hasAccess(toArea: .rideControl))
        XCTAssertFalse(pass.allRideAccess)
        XCTAssertFalse(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 0)
        XCTAssertEqual(pass.merchandiseDiscount, 0)
    }
    
    func test1002ContractorType() {
        let pass = passGenerator.createPass(forEntrant: ContractorType.oneZeroZeroTwo(name: entrantName, address: entrantAddress, birthdate: entrantBirthdate, socialSecurityNumber: entrantSocialSecurityNumber))
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertFalse(pass.hasAccess(toArea: .kitchen))
        XCTAssertTrue(pass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(pass.hasAccess(toArea: .office))
        XCTAssertTrue(pass.hasAccess(toArea: .rideControl))
        XCTAssertFalse(pass.allRideAccess)
        XCTAssertFalse(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 0)
        XCTAssertEqual(pass.merchandiseDiscount, 0)
    }
    
    func test1003ContractorType() {
        let pass = passGenerator.createPass(forEntrant: ContractorType.oneZeroZeroThree(name: entrantName, address: entrantAddress, birthdate: entrantBirthdate, socialSecurityNumber: entrantSocialSecurityNumber))
        XCTAssertTrue(pass.hasAccess(toArea: .amusement))
        XCTAssertTrue(pass.hasAccess(toArea: .kitchen))
        XCTAssertTrue(pass.hasAccess(toArea: .maintenance))
        XCTAssertTrue(pass.hasAccess(toArea: .office))
        XCTAssertTrue(pass.hasAccess(toArea: .rideControl))
        XCTAssertFalse(pass.allRideAccess)
        XCTAssertFalse(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 0)
        XCTAssertEqual(pass.merchandiseDiscount, 0)
    }
    
    func test2001ContractorType() {
        let pass = passGenerator.createPass(forEntrant: ContractorType.twoZeroZeroOne(name: entrantName, address: entrantAddress, birthdate: entrantBirthdate, socialSecurityNumber: entrantSocialSecurityNumber))
        XCTAssertFalse(pass.hasAccess(toArea: .amusement))
        XCTAssertFalse(pass.hasAccess(toArea: .kitchen))
        XCTAssertFalse(pass.hasAccess(toArea: .maintenance))
        XCTAssertTrue(pass.hasAccess(toArea: .office))
        XCTAssertFalse(pass.hasAccess(toArea: .rideControl))
        XCTAssertFalse(pass.allRideAccess)
        XCTAssertFalse(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 0)
        XCTAssertEqual(pass.merchandiseDiscount, 0)
    }
    
    func test2002ContractorType() {
        let pass = passGenerator.createPass(forEntrant: ContractorType.twoZeroZeroTwo(name: entrantName, address: entrantAddress, birthdate: entrantBirthdate, socialSecurityNumber: entrantSocialSecurityNumber))
        XCTAssertFalse(pass.hasAccess(toArea: .amusement))
        XCTAssertTrue(pass.hasAccess(toArea: .kitchen))
        XCTAssertTrue(pass.hasAccess(toArea: .maintenance))
        XCTAssertFalse(pass.hasAccess(toArea: .office))
        XCTAssertFalse(pass.hasAccess(toArea: .rideControl))
        XCTAssertFalse(pass.allRideAccess)
        XCTAssertFalse(pass.skipsQueues)
        XCTAssertEqual(pass.foodDiscount, 0)
        XCTAssertEqual(pass.merchandiseDiscount, 0)
    }
    
    // Sound
    func testSound() {
        XCTAssertNotNil(passReader.playSound(true))
        XCTAssertNotNil(passReader.playSound(false))
    }
}
