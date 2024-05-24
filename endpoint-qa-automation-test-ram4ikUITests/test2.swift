import XCTest

class GmailAutomationDragDropTests2: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        
        copyFileToDocuments(filename: "attachments.txt")
        copyFileContentsToClipboard(filename: "attachments.txt")
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

        googleApp.typeText("\t\t")

        googleApp.typeKey("v", modifierFlags: [.command])

        let bodyTextView = googleApp.textViews.element(boundBy: 0)
        XCTAssertTrue(bodyTextView.waitForExistence(timeout: 10))
        
        let attachment = googleApp.staticTexts["attachments.txt"]
        XCTAssertTrue(attachment.waitForExistence(timeout: 10))
    }
}
