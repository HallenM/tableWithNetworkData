//
//  BaseViewModel.swift
//  app03.2.0
//
//  Created by developer on 23.02.2021.
//

import UIKit

/// Description of functions that can interact with inner data of the table and can help to change the view of cells in the table
protocol BaseViewDelegateProtocol: class {
    /**
     Changing value in the cell in the table.
     
     - Parameter index: The index of current cell for changing
     */
    func reloadCell(index: Int)
    
    /**
     Insert new cell after selected cell.
     
     - Parameters index: The index of new cell.
     */
    func insertCell(index: Int)
    
    /**
     Delete selected cell
     
     - Parameter index: The index of cell for delete.
     */
    func removeCell(index: Int)
    
    /**
     Updating the view of cells below selected cell.
     
     - Parameter index: The index corresponding to the cell
     */
    func doRefresh(index: Int)
    
    func showActivityIndicator()
    
    func hideActivityIndicator()
}

/// Model which is managing a inner data of the table
class BaseViewModel {
    
    /// Object that helps you manage and change table cells
    weak var viewDelegate: BaseViewDelegateProtocol?
    
    weak var actionDelegate: AppCoordinatorActionDelegateProtocol?
    
    /// Inner presentation the list of data in the table
    private var listOfMealCategories = [MealCategory]()
    
    /// The index corresponding to the cell which was selected
    private var index: Int?
    
    private let networkService: NetworkService = NetworkService()
    
    /**
     Initializes a new list of data for create the new table.
     */
    func initData(completion: @escaping () -> Void) {
        viewDelegate?.showActivityIndicator()
        genDataForTable(isNeedActivityIndicator: true, completion: completion)
    }
    
    /**
     Generate the list with some strings of special view.
     */
    func genDataForTable(isNeedActivityIndicator: Bool = false, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(2)
            self.networkService.fetchMealCategories{ (result) in
                switch result {
                case .success(let mealCategories):
                    self.listOfMealCategories = mealCategories
                case .failure(_):
                    self.listOfMealCategories = [MealCategory]()
                    return
                }
                
                completion()
                
                if isNeedActivityIndicator {
                    self.viewDelegate?.hideActivityIndicator()
                }
            }
        }
    }
    
    /**
     Get the index corresponding to selecting cell.
     
     - Returns: The index corresponding to cell or 0 as default.
     */
    func getIndex() -> Int {
        return index ?? 0
    }
    
    /**
     Save the index corresponding to selecting cell in the model.
     
     - Parameter index: The index corresponding to selecting cell.
     */
    func setIndex(_ index: Int) {
        self.index = index
    }
    
    /**
     Get the count of row in the table.
     
     - Returns: The count of rows in innner data.
     */
    func getListCount() -> Int {
        return listOfMealCategories.count
    }
    
    /**
     Get the inner value correspond to cell of the table.
     
     - Parameter index: The index corresponding to selecting cell.
     
     - Returns: The string wich correspond to value of cell in the table.
     */
    func getListValue(index: Int) -> String {
        return listOfMealCategories[index].name ?? ""
    }
    
    /**
     Set the inner value correspond to cell of the table and call the method of reload cell on table.
     
     - Parameters:
         - index: The index corresponding to the cell
         - data: The text for setting in the inner data instead of current text
     */
    func changeValue(index: Int, data: String) {
        listOfMealCategories[index].name = data
        viewDelegate?.reloadCell(index: index)
    }
    
    /**
     Add the new inner value in the list of data and call method of add new cell and
     method of refreshing cells in the table.
     
     - Parameters:
         - index: The index corresponding to the cell
         - data: The text for adding in the inner data after current text
     */
    func insertNewValue(index: Int, data: String) {
        var mealCategory = listOfMealCategories[index - 1]
        mealCategory.name = data
        
        listOfMealCategories.insert(mealCategory, at: index)
        
        viewDelegate?.insertCell(index: index)
        
        if index < listOfMealCategories.count - 1 {
            viewDelegate?.doRefresh(index: index + 1)
        }
    }
    
    /**
     Delete the current inner value from the list of data and call method of delete cell
     and method of refreshing cells in the table.
     
     - Parameter index: The index corresponding to selecting cell.
     */
    func removeCellValue(index: Int) {
        listOfMealCategories.remove(at: index)
        viewDelegate?.removeCell(index: index)
        if index < listOfMealCategories.count {
            viewDelegate?.doRefresh(index: index)
        }
    }
    
    /**
     Get the color for the index corresponding to selecting cell.
     
     - Parameter index: The index corresponding to selecting cell.
     
     - Returns: The color.
     */
    func getColor(index: Int) -> UIColor {
        return (index % 2 == 1) ? .red : .black
    }
    
    /**
     Create new array based on the sequence of numbers which started on the index
     corresponding to selecting cell and ended on the last index of the list of inner data.
     
     - Parameter index: The index corresponding to selecting cell.
     
     - Returns: The array of a sequence of numbers.
     */
    func createArray(index: Int) -> [Int] {
        return Array(index...listOfMealCategories.count)
    }
    
    func didTapOnCell(with data: String, isEditing: Bool, index: Int) {
        actionDelegate?.showEditScreeen(with: data, isEditing: isEditing, index: index)
    }
    
    func changeCellState(with data: String, isEditing: Bool, index: Int) {
        if isEditing {
            // replace data inside sell
            self.changeValue(index: index, data: data)
        } else {
            // insert new cell
            self.insertNewValue(index: index + 1, data: data)
        }
    }
}
