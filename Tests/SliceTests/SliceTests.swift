import XCTest
import Files
import PDFKit
@testable import Slice

final class SliceTests: XCTestCase {
    
    var testFolder: Folder!
    
    override func setUp() {
        super.setUp()
        testFolder = try! Folder.home.createSubfolder(named: ".sliceTests")
        try! testFolder.empty()
    }
    
    override func tearDown() {
        try? testFolder.delete()
        super.tearDown()
    }
    
    func testPassingIncompatibleFileToFileParameter() throws {
        let path = Bundle.module.path(forResource: "cat", ofType: "png")
        XCTAssertNotNil(path, "Local resource expected and not found.")
        let file = try File(path: path!)
        let slice = Slice(file: file, output: testFolder)
        XCTAssertThrowsError(try slice.run())
    }
    
    func testSlicesAndOutputDefaultParameters() throws {
        let name1 = "Checkout - Part1.pdf"
        let name2 = "Checkout - Part2.pdf"
        XCTAssertThrowsError(try Folder.home.file(named: name1))
        XCTAssertThrowsError(try Folder.home.file(named: name2))
        let path = Bundle.module.path(forResource: "checkout", ofType: "pdf")
        XCTAssertNotNil(path, "Local resource expected and not found.")
        let slice = Slice(file: try File(path: path!))
        try slice.run()
        let file = try Folder.current.file(named: name1)
        try? file.delete()
        XCTAssertThrowsError(try Folder.current.file(named: name2))
    }
    
    func testPassingArgumentToSlicesParameter() throws {
        let path = Bundle.module.path(forResource: "checkout", ofType: "pdf")
        XCTAssertNotNil(path, "Local resource expected and not found.")
        let slices: Int = 2
        let slice = Slice(file: try File(path: path!), slices: slices, output: testFolder)
        try slice.run()
        XCTAssertEqual(slices, testFolder.files.count())
    }
        
    func testFilesCount() throws {
        let name1 = "Checkout - Part1.pdf"
        let name2 = "Checkout - Part2.pdf"
        let name3 = "Checkout - Part3.pdf"
        let name4 = "Checkout - Part4.pdf"
        XCTAssertThrowsError(try testFolder.file(named: name1))
        XCTAssertThrowsError(try testFolder.file(named: name2))
        XCTAssertThrowsError(try testFolder.file(named: name3))
        XCTAssertThrowsError(try testFolder.file(named: name4))
        let path = Bundle.module.path(forResource: "checkout", ofType: "pdf")
        XCTAssertNotNil(path, "Local resource expected and not found.")
        let file = try File(path: path!)
        let slices: Int = 4
        let slice = Slice(file: file, slices: slices, output: testFolder)
        try slice.run()
        XCTAssertEqual(slices, testFolder.files.count())
        XCTAssertNoThrow(try testFolder.file(named: name1))
        XCTAssertNoThrow(try testFolder.file(named: name2))
        XCTAssertNoThrow(try testFolder.file(named: name3))
        XCTAssertNoThrow(try testFolder.file(named: name4))
    }
    
    func testPagesCount() throws {
        let path = Bundle.module.path(forResource: "checkout", ofType: "pdf")
        XCTAssertNotNil(path, "Local resource expected and not found.")
        let file = try File(path: path!)
        let slices: Int = 4
        let slice = Slice(file: file, slices: slices, output: testFolder)
        try slice.run()
        for (index, file) in testFolder.files.enumerated() {
            let document = PDFDocument(url: file.url)
            XCTAssertNotNil(document)
            let pageCount = document!.pageCount
            if index < 3 {
                XCTAssertEqual(10, pageCount)
            } else {
                XCTAssertEqual(9, pageCount)
            }
        }
    }
    
    static var allTests = [(
        "testPassingIncompatibleFileToFileParameter", testPassingIncompatibleFileToFileParameter,
        "testSlicesAndOutputDefaultParameters", testSlicesAndOutputDefaultParameters,
        "testPassingArgumentToSlicesParameter", testPassingArgumentToSlicesParameter,
        "testFilesCount", testFilesCount,
        "testPagesCount", testPagesCount
    )]
}
