//
//  CellViewController.swift
//  app03.2.0
//
//  Created by developer on 16.02.2021.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet private weak var cellTextField: UITextField!
    
    @IBOutlet private weak var btnApply: UIButton!
    
    var editViewModel: EditViewModel = EditViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        cellTextField.text = editViewModel.getText()
        editViewModel.editViewDelegate = self
    }
    
    @IBAction private func applyChanges(_ sender: Any) {
        let resultOfChanges: String? = cellTextField.text
        if let resultOfChanges = resultOfChanges {
            // save data to table
            editViewModel.didTapButton(with: resultOfChanges)
        }
    }
}

extension EditViewController: EditViewModelViewDelegate {
    func close(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}
