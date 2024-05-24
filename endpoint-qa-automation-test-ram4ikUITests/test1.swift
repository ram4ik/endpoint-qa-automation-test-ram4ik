import XCTest

class GmailAutomationDragDropTests1: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        
        copyFileToDocuments(filename: "attachments.txt")
    }

    func testComposeEmailWithDragAndDropAttachment() {
        let googleApp = XCUIApplication(bundleIdentifier: "com.google.Chrome")
        googleApp.launch()
        
        googleApp.activate()
        googleApp.menuBars.menuBarItems["File"].menus.menuItems["New Tab"].click()
        googleApp.typeKey("t", modifierFlags: [.command])
        googleApp.typeText("https://mail.google.com\n")
        
        sleep(3)

        let composeButton = googleApp.buttons["Compose"]
        XCTAssertTrue(composeButton.waitForExistence(timeout: 10))
        composeButton.click()
        
        sleep(2)

        // Locate the file in Finder
        let finderApp = XCUIApplication(bundleIdentifier: "com.apple.finder")
        finderApp.activate()
        
        let documentsFolder = finderApp.windows.firstMatch
        XCTAssertTrue(documentsFolder.waitForExistence(timeout: 10))
        
        let attachmentFile = documentsFolder.icons["attachments.txt"]
        XCTAssertTrue(attachmentFile.waitForExistence(timeout: 10))

        // Start the drag action
        let startCoordinate = attachmentFile.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        startCoordinate.press(forDuration: 1.5, thenDragTo: startCoordinate.withOffset(CGVector(dx: 0, dy: -200)))

        // Switch back to the Chrome app with Gmail compose window open
        googleApp.activate()
        let bodyArea = googleApp.textViews.element(boundBy: 0)
        XCTAssertTrue(bodyArea.waitForExistence(timeout: 10))
        
        // Complete the drop action
        let endCoordinate = bodyArea.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        startCoordinate.press(forDuration: 0.1, thenDragTo: endCoordinate)

        sleep(2)  // Allow time for the drag-and-drop action to complete

        let attachment = googleApp.staticTexts["attachments.txt"]
        XCTAssertTrue(attachment.waitForExistence(timeout: 10))
    }
}
