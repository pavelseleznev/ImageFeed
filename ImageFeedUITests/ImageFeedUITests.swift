//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Pavel Seleznev on 3/12/25.
//

@testable import ImageFeed
import XCTest

private let email = "seleznevpm@icloud.com"
private let password = "qydqun-zadbi8-Sedqer"
private let fullName = "Pavel Seleznev"
private let username = "@pavel_seleznev"

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UITests"]
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        
        let continueButton = app.buttons["Continue"]
        if continueButton.waitForExistence(timeout: 5) {
            continueButton.tap()
            sleep(2)
        }
        
        loginTextField.typeText(email)
        app.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        sleep(2)
        passwordTextField.typeText(password)
        app.buttons["Done"].tap()
        
        let loginButton = webView.buttons["Login"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 3))
        
        loginButton.tap()
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        cell.swipeUp()
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        app.swipeDown()
        
        let likeButton = cellToLike.buttons["LikeButton"]
        if likeButton.waitForExistence(timeout: 5) {
            likeButton.tap()
            sleep(3)
            likeButton.tap()
            sleep(3)
        }
        
        cellToLike.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["Nav Back Button White"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        //sleep(2)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[fullName].exists)
        XCTAssertTrue(app.staticTexts[username].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
