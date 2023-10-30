//
//  PresenterTests.swift
//  EmployeInfoTests
//
//  Created by Stoyan Kostov on 30.10.23.
//

@testable import EmployeInfo
import XCTest

final class PresenterTests: XCTestCase {

    private final class MockViewController: ViewControllerInput {
        var viewModel: ViewModel?

        func display(viewModel: ViewModel) {
            self.viewModel = viewModel
        }
    }

    private var presenter: Presenter!
    private var mockViewController: MockViewController!

    override func setUp() {
        super.setUp()
        mockViewController = MockViewController()
        presenter = Presenter(viewController: mockViewController)
    }

    func testProcessCSVFile() {
        let tempDir = NSTemporaryDirectory()
        let tempURL = URL(fileURLWithPath: tempDir).appendingPathComponent("test.csv")
        let csvContent = "1,1,2023-01-01,2023-01-05\n2,1,2023-01-02,2023-01-06\n3,2,2023-01-03,2023-01-07\n"
        try? csvContent.write(to: tempURL, atomically: true, encoding: .utf8)

        presenter.processCSVFile(at: tempURL)

        XCTAssertNotNil(mockViewController.viewModel)
    }

    func testProcessCVVCalculation() {
        let tempDir = NSTemporaryDirectory()
        let tempURL = URL(fileURLWithPath: tempDir).appendingPathComponent("test.csv")
        let csvContent = "EmpID,ProjectID,DateFrom,DateTo\n143,12,2013-11-01,2014-01-05\n218,10,2012-05-16,NULL\n143,10,2009-01-01,2011-04-27\n218,12,2012-11-01, 2014-05-20\n143,15,2010-03-12,2012-08-30\n218,15,2011-06-05,2013-09-10\n"
        try? csvContent.write(to: tempURL, atomically: true, encoding: .utf8)

        presenter.processCSVFile(at: tempURL)

        XCTAssertEqual(
            mockViewController.viewModel,
            .init(
                firstEmployeeID: 143,
                secondEmployeeID: 218,
                projectID: 15,
                daysWorkedTogether: 452
            ))
    }

    func testProcessCVVCalculationDifferentDateFormats() {
        let tempDir = NSTemporaryDirectory()
        let tempURL = URL(fileURLWithPath: tempDir).appendingPathComponent("test.csv")
        let csvContent = "EmpID,ProjectID,DateFrom,DateTo\n143,12,2013-11-01,2014/01/05\n218,10,05-16-2012,N/A\n143,10,01/01/2009,27-Apr-2011\n218,12,01-Nov-2012,2014-05-20\n143,15,12-Mar-2010,2012/08/30\n218,15,2011-06-05,10-Sept-2013\n"
        try? csvContent.write(to: tempURL, atomically: true, encoding: .utf8)

        presenter.processCSVFile(at: tempURL)

        XCTAssertEqual(
            mockViewController.viewModel,
            .init(
                firstEmployeeID: 143,
                secondEmployeeID: 218,
                projectID: 15,
                daysWorkedTogether: 452
            ))
    }

    override func tearDown() {
        // Clean up and remove the temporary CSV file
        let tempDir = NSTemporaryDirectory()
        let tempURL = URL(fileURLWithPath: tempDir).appendingPathComponent("test.csv")
        try? FileManager.default.removeItem(at: tempURL)

        super.tearDown()
    }
}
