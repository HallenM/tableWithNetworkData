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
    
    weak var viewModel: EditViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        cellTextField.text = viewModel?.getText()
    }
    
    @IBAction private func applyChanges(_ sender: Any) {
        let resultOfChanges: String? = cellTextField.text
        if let resultOfChanges = resultOfChanges {
            // save data to table
            viewModel?.didTapButton(with: resultOfChanges)
        }
    }
}
