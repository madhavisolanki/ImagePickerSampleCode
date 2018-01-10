//
//  SwiftSampleCodeUITests.swift
//  SwiftSampleCodeUITests
//
//  Created by Madhavi Solanki on 13/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import XCTest

class SwiftSampleCodeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testFlickrAPI() {
        
        let app = XCUIApplication()
        app.navigationBars["Photo Gallery"].buttons["icon add"].tap()
        
        let importFromFlickrButton = app.sheets.buttons["Import from Flickr"]
        importFromFlickrButton.tap()
        importFromFlickrButton.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 18).children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 19).otherElements.containing(.image, identifier:"iconCheck").children(matching: .other).element.tap()
        app.navigationBars["Select 2 Flickr Photos"].buttons["Done"].tap()
        
    }
    
    func testPhotoGallery() {
        
        let app = XCUIApplication()
        app.navigationBars["Photo Gallery"].buttons["icon add"].tap()
        app.sheets.buttons["Photo library"].tap()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        window.children(matching: .other).element(boundBy: 1).tap()
        window.children(matching: .other).element.children(matching: .other).element(boundBy: 1).collectionViews.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 3).children(matching: .other).element.tap()
        app.navigationBars["Select 2 picture"].buttons["Done"].tap()
        app.navigationBars["SwiftSampleCode.PhotoGalleryDetailView"].buttons["Send"].tap()
        
    }
    

}
