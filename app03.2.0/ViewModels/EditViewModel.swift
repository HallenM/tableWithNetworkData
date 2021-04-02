//
//  EditViewModel.swift
//  app03.2.0
//
//  Created by developer on 23.02.2021.
//

import UIKit

/// Model which is managing a process of changing internal text in selected cell
class EditViewModel {
    
    weak var actionDelegate: AppCoordinatorActionDelegateProtocol?
    
    /// The storage of text from cell
    private var textFromCell: String
    
    /// The index of cell which was selecting
    private var index: Int
    
    /// Press type pointer
    var isEditing: Bool = true
    
    init(with data: String, isEditing: Bool, index: Int) {
        self.textFromCell = data
        self.isEditing = isEditing
        self.index = index
    }
    
    /**
     Get the text from cell for further putting it into textfield.
     
     - Returns: The text wich will be putting into textfield.
     */
    func getText() -> String {
        return textFromCell
    }
    
    /**
     Set the text into the cell.
     
     - Parameter text: The text wich will put into text cell storage.
     */
    func setText(_ text: String) {
        textFromCell = text
    }
    
    /**
     Save the index of selecting cell in the model.
     
     - Parameter index: The index of selecting cell.
     */
    func setIndex(_ index: Int) {
        self.index = index
    }
    
    /**
     The actions which were happened after tap on the button.
     
     - Parameter text: The text fom cell after some changing.
     */
    func didTapButton(with text: String) {
        actionDelegate?.safeDataAndCloseEditScreen(with: text, isEditing: isEditing, index: index)
    }
}
