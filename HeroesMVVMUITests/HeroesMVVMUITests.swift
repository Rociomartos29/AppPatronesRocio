//
//  HeroesMVVMUITests.swift
//  HeroesMVVMUITests
//
//  Created by Rocio Martos on 25/1/24.
//

import XCTest

final class HeroesMVVMUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    func testLoginAndNavigateToHome() {
        // Asegúrate de que la aplicación ha cargado
        XCTAssertTrue(app.staticTexts["Bienvenido"].exists)
        
        // Realiza el login (ajusta según tu interfaz de usuario)
        let emailTextField = app.textFields["EmailTextField"]
        let passwordTextField = app.secureTextFields["PasswordTextField"]
        let loginButton = app.buttons["LoginButton"]
        
        emailTextField.tap()
        emailTextField.typeText("")
        
        passwordTextField.tap()
        passwordTextField.typeText("")
        
        loginButton.tap()
        
        XCTAssertTrue(app.navigationBars["Inicio"].exists)
    }
    func testNavigateToDetalles() {
        XCTAssertTrue(app.navigationBars["Inicio"].exists)
        
        XCTAssertTrue(app.tables.cells.count > 0)
        
        app.tables.cells.element(boundBy: 0).tap()
        
        XCTAssertTrue(app.navigationBars["Detalles"].exists)
    }
}
