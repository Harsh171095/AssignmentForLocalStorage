//
//  RegisterScreenTests.swift
//  AssignmentForLocalStorageTests
//
//  Created by admin on 25/04/24.
//

import XCTest
@testable import AssignmentForLocalStorage

final class RegisterScreenTests: XCTestCase {

    func testLoginFieldValidationsFailure1() throws {
        let viewmodel = RegisterViewModel()
        let userModel = RegisterRequestModel(fullName: "", email: "", password: "", confirmPassword: "")
        
        XCTAssertThrowsError(try viewmodel.isUserValid(userModel: userModel))
    }
    
    func testLoginFieldValidationsFailure2() throws {
        let viewmodel = RegisterViewModel()
        let userModel = RegisterRequestModel(fullName: "harsh", email: "harsh", password: "test", confirmPassword: "test1")
        
        XCTAssertThrowsError(try viewmodel.isUserValid(userModel: userModel))
    }
    
    func testLoginFieldValidationsFailure3() throws {
        let viewmodel = RegisterViewModel()
        let userModel = RegisterRequestModel(fullName: "harsh", email: "harsh@gmail", password: "test", confirmPassword: "test1")
        
        XCTAssertThrowsError(try viewmodel.isUserValid(userModel: userModel))
    }
    
    func testLoginFieldValidationsFailure4() throws {
        let viewmodel = RegisterViewModel()
        let userModel = RegisterRequestModel(fullName: "harsh", email: "harsh@gmail.com", password: "test", confirmPassword: "test1")
        
        XCTAssertThrowsError(try viewmodel.isUserValid(userModel: userModel))
    }
    
    func testLoginFieldValidationsFailure5() throws {
        let viewmodel = RegisterViewModel()
        let userModel = RegisterRequestModel(fullName: "harsh", email: "harsh@gmail.com", password: "test123", confirmPassword: "test1")
        
        XCTAssertThrowsError(try viewmodel.isUserValid(userModel: userModel))
        
    }
    
    func testLoginFieldValidationsSuccess1() throws {
        let viewmodel = RegisterViewModel()
        let userModel = RegisterRequestModel(fullName: "harsh", email: "harsh@gmail.com", password: "test123", confirmPassword: "test123")
        
        XCTAssertNoThrow(try viewmodel.isUserValid(userModel: userModel))
    }
    
    func testLoginFieldValidationsSuccess2() throws {
        let viewmodel = RegisterViewModel()
        let userModel = RegisterRequestModel(fullName: "harsh", email: "harsh.harsh@gmail.com", password: "test123", confirmPassword: "test123")
        
        XCTAssertNoThrow(try viewmodel.isUserValid(userModel: userModel))
    }

}
