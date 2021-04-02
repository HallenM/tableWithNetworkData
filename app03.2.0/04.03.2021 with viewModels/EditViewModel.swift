//
//  EditViewModel.swift
//  app03.2.0
//
//  Created by developer on 23.02.2021.
//

import UIKit

/// The description of features connected with the changing the options from some cell.
protocol ChangeValueDelegate: class {
    /**
     Execute some actions if cell value was changed.
     
     - Parameters:
         - sender: Any object which can call the function
         - data: The text which will replace old value from cell
         - isEditing: The kind of the type of press
         - index: The index of cell in which the text will be replacing
     */
    func didChangeValue(_ sender: AnyObject, data: String, isEditing: Bool, index: Int)
}

/// The description of some features wich can be executed
protocol EditViewModelViewDelegate: class {
    /**
     Close the openi view and go to the root view.
     
     - Parameter sender: Any object which can call the function.
     */
    func close(_ sender: AnyObject)
}

/// Model which is managing a process of changing internal text in selected cell
class EditViewModel {
    
    /// Object who receive the part of work for executing from this model, isn`t connecting with this model
    weak var delegate: ChangeValueDelegate?
    
    /// Object connecting with this model and receive the part of work from this model
    weak var editViewDelegate: EditViewModelViewDelegate?
    
    /// The storage of text from cell
    private var textFromCell: String!
    
    /// The index of cell which was selecting
    private var index: Int?
    
    /// Press type pointer
    var isEditing: Bool = true
    
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
        delegate?.didChangeValue(self, data: text, isEditing: isEditing, index: index ?? 0)
        editViewDelegate?.close(self)
    }
}
