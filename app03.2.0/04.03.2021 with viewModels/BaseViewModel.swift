//
//  BaseViewModel.swift
//  app03.2.0
//
//  Created by developer on 23.02.2021.
//

import UIKit
import Alamofire

/// Description of functions that can interact with inner data of the table and can help to change the view of cells in the table
protocol BaseViewDelegate: class {
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
}

/// Model which is managing a inner data of the table
class BaseViewModel {
    
    /// Object that helps you manage and change table cells
    weak var delegate: BaseViewDelegate?
    
    /// Inner presentation the list of data in the table
    private var listOfString = [String]()
    
    /// The index corresponding to the cell which was selected
    private var index: Int?
    
    /**
     Initializes a new list of data for create the new table.
     */
    func initData(completion: @escaping () -> Void) {
        genDataForTable(completion: completion)
    }
    
    /**
     Generate the list with some strings of special view.
     */
    func genDataForTable(completion: @escaping () -> Void) {
        
        /* Old generation of inner data
         for i in 0..<100 {
            listOfString.append("cell number \(i+1)")
        }*/
        
        /*Alamofire.request(
            "https://www.themealdb.com/api/json/v1/1/categories.php",
            method: .get)
            .validate()
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success:
                    
                    guard let jsonArray = responseJSON.result.value as? [String: AnyObject] else { return }
                    
                    guard let innerArray = jsonArray["categories"] as? [AnyObject] else { return }
                    
                    for elements in innerArray {
                        guard let element = elements["strCategory"] as? String else { return }
                        self.listOfString.append("Category \(element)")
                    }
                    completion()
                case .failure(let error):
                    print("Fail_resp:  \(error)")
                }
            }*/
        
        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else { return }
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonArray = json as? [String: AnyObject] else { return }
                
                guard let innerArray = jsonArray["categories"] as? [AnyObject] else { return }
                
                for elements in innerArray {
                    guard let element = elements["strCategory"] as? String else { return }
                    self.listOfString.append("Category \(element)")
                }
                completion()
            } catch {
                print ("Error::   \(error)")
            }
        }.resume()
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
        return listOfString.count
    }
    
    /**
     Get the inner value correspond to cell of the table.
     
     - Parameter index: The index corresponding to selecting cell.
     
     - Returns: The string wich correspond to value of cell in the table.
     */
    func getListValue(index: Int) -> String {
        return listOfString[index]
    }
    
    /**
     Set the inner value correspond to cell of the table and call the method of reload cell on table.
     
     - Parameters:
         - index: The index corresponding to the cell
         - data: The text for setting in the inner data instead of current text
     */
    func changeValue(index: Int, data: String) {
        listOfString[index] = data
        delegate?.reloadCell(index: index)
    }
    
    /**
     Add the new inner value in the list of data and call method of add new cell and
     method of refreshing cells in the table.
     
     - Parameters:
         - index: The index corresponding to the cell
         - data: The text for adding in the inner data after current text
     */
    func insertNewValue(index: Int, data: String) {
        listOfString.insert(data, at: index)
        delegate?.insertCell(index: index)
        if index != listOfString.count {
            delegate?.doRefresh(index: index + 1)
        }
    }
    
    /**
     Delete the current inner value from the list of data and call method of delete cell
     and method of refreshing cells in the table.
     
     - Parameter index: The index corresponding to selecting cell.
     */
    func removeCellValue(index: Int) {
        listOfString.remove(at: index)
        delegate?.removeCell(index: index)
        if index != listOfString.count {
            delegate?.doRefresh(index: index)
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
        return Array(index...listOfString.count - 1)
    }
}
