//
//  ViewController.swift
//  app03.2.0
//
//  Created by developer on 15.02.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "TableViewCell"
    
    var baseViewModel: BaseViewModel = BaseViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        baseViewModel.delegate = self
        
        // add in table longpress tap
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.addTarget(self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        self.tableView.addGestureRecognizer(longPressGesture)
        
        baseViewModel
            .initData(completion: {
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            // get point in which we tap on cell
            let touchPoint = sender.location(in: self.tableView)
            // get indexPath of cell in tapping point
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {

                baseViewModel.setIndex(indexPath.row)
                
                self.navigationController?.isNavigationBarHidden = false
                
                let textInCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
                
                guard let editCellVC = storyboard?.instantiateViewController(identifier: "CellViewController") as? EditViewController else {
                    return
                }
                
                editCellVC.editViewModel.delegate = self
                editCellVC.editViewModel.setIndex(indexPath.row)
                editCellVC.editViewModel.setText(textInCell ?? "")
                editCellVC.editViewModel.isEditing = false
                self.navigationController?.pushViewController(editCellVC, animated: true)
            }
        }
    }
}

extension ViewController: BaseViewDelegate {
    
    func reloadCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func insertCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .bottom)
    }
    
    func removeCell(index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func doRefresh(index: Int) {
        let refreshArray = baseViewModel.createArray(index: index).map{IndexPath(row: $0, section: 0)}
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: refreshArray, with: .bottom)
        }
    }
}

// method for delegate
extension ViewController: ChangeValueDelegate {
    func didChangeValue(_ sender: AnyObject, data: String, isEditing: Bool, index: Int) {
        if isEditing {
            // replace data inside sell
            baseViewModel.changeValue(index: index, data: data)
        } else {
            // insert new cell
            baseViewModel.insertNewValue(index: index + 1, data: data)
        }
    }
}

extension ViewController: UITableViewDelegate {
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        baseViewModel.setIndex(indexPath.row)
        
        self.navigationController?.isNavigationBarHidden = false
        
        let textInCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        guard let editCellVC = storyboard?.instantiateViewController(identifier: "CellViewController") as? EditViewController else {
            return
        }
        
        editCellVC.editViewModel.delegate = self
        editCellVC.editViewModel.setIndex(indexPath.row)
        editCellVC.editViewModel.setText(textInCell ?? "")
        self.navigationController?.pushViewController(editCellVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    // get number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseViewModel.getListCount()
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = baseViewModel.getListValue(index: indexPath.row)
        cell.textLabel?.textColor = baseViewModel.getColor(index: indexPath.row)
        //cell.textLabel?.isHidden = (indexPath.row % 5 == 4)
        if indexPath.row % 5 == 4 {
            cell.textLabel?.textColor = UIColor.blue
        }
        
        return cell
    }
    
    // delete a cell in table through swipe to the left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            baseViewModel.removeCellValue(index: indexPath.row)
        }
    }
}

