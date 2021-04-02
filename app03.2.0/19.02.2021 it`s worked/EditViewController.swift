//
//  CellViewController.swift
//  app03.2.0
//
//  Created by developer on 16.02.2021.
//

import UIKit

protocol ChangeValueDelegate: class {
    func didChangeValue(_ sender: EditViewController, data: String)
}

class EditViewController: UIViewController {
    
    @IBOutlet private weak var cellTextField: UITextField!
    @IBOutlet private weak var btnApply: UIButton!
    
    var textFromCell: String!
    weak var delegate: ChangeValueDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        cellTextField.text = textFromCell
    }
    
    @IBAction func applyChanges(_ sender: Any) {
        let resultOfChanges: String? = cellTextField.text
        if let resultOfChanges = resultOfChanges {
            // save data to table
            delegate?.didChangeValue(self, data: resultOfChanges)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
