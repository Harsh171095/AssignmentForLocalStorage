//
//  AssignmentForLocalStorageTests.swift
//  AssignmentForLocalStorageTests
//
//  Created by admin on 16/04/24.
//

import XCTest
@testable import AssignmentForLocalStorage

final class LoginScreenTests: XCTestCase {

    func testLoginFieldValidationsFailure1() throws {
       let viewmodel = LoginViewModel()
        if let message = viewmodel.isUserValid(email: "hasrh", password: "") {
            XCTAssertTrue(true, message)
        }
        else {
            XCTAssertTrue(false)
        }
    }
    
    func testLoginFieldValidationsFailure2() throws {
        let viewmodel = LoginViewModel()
        
        if let message = viewmodel.isUserValid(email: "hasrh", password: "asdsa") {
            XCTAssertTrue(true, message)
        }else {
            XCTAssertTrue(false)
        }
    }
    
    func testLoginFieldValidationsFailure3() throws {
        let viewmodel = LoginViewModel()
        if let message = viewmodel.isUserValid(email: "hasrh@asasa@asass.asa", password: "asdsa") {
            XCTAssertTrue(true, message)
        }else {
            XCTAssertTrue(false)
        }
    }
    
    func testLoginFieldValidationsSuccess1() throws {
        let viewmodel = LoginViewModel()
       // Succcess
        if let message = viewmodel.isUserValid(email: "hasrh@asasasass.asa", password: "test@123") {
            XCTAssertTrue(false, message)
        }else {
            XCTAssertTrue(true)
        }
    }
    
    func testLoginFieldValidationsSuccess2() throws {
        let viewmodel = LoginViewModel()
       
        if let message = viewmodel.isUserValid(email: "hasrh.asa12@asasasass.asa", password: "test@123") {
            XCTAssertTrue(false, message)
        }else {
            XCTAssertTrue(true)
        }
    }
}
