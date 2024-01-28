//
//  HeroesMVVMTests.swift
//  HeroesMVVMTests
//
//  Created by Rocio Martos on 25/1/24.
//

import XCTest
@testable import HeroesMVVM

final class HeroesMVVMTests: XCTestCase {
    private var token: String?
    
    override func setUp() {
        super.setUp()
        print("SetUp para cada test")
    }
    
    override class func setUp() {
        super.setUp()
        print("SetUp para toda la clase")
    }
    
    override func tearDown() {
        super.tearDown()
        print("TearDown para cada test")
    }
    
    override class func tearDown() {
        super.tearDown()
        print("TearDown para toda la clase")
    }

    func test_helloWorld() {
        token = "Hello World!"
        
        XCTAssertEqual(token, "Hello World!")
        XCTAssertNotEqual(token, "Hola Mundo!")
    }

    func test_notHelloWorld() {
        XCTAssertNil(token)
    }
}
