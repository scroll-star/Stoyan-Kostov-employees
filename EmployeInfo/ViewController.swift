//
//  ViewController.swift
//  EmployeInfo
//
//  Created by Stoyan Kostov on 29.10.23.
//

import UIKit

struct ViewModel: Equatable {
    let firstEmployeeID: Int
    let secondEmployeeID: Int
    let projectID: Int
    let daysWorkedTogether: UInt
}

protocol ViewControllerInput: AnyObject {
    func display(viewModel: ViewModel)
}

final class ViewController: UIViewController {

    @IBOutlet private weak var resultLabel: UILabel!

    var processDocumentHandler: ((URL) -> Void)?

    private func showDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    @IBAction private func onButtonTap() {
        showDocumentPicker()
    }
}

extension ViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            assertionFailure("Missing required URL input")
            return
        }
        processDocumentHandler?(url)
    }
}

extension ViewController: ViewControllerInput {
    func display(viewModel: ViewModel) {
        resultLabel.text = "\(viewModel.firstEmployeeID), \(viewModel.secondEmployeeID), \(viewModel.projectID), \(viewModel.daysWorkedTogether)"
        resultLabel.isHidden = false
    }
}
