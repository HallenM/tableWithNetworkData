//
//  ViewController.swift
//  app03.2.0
//
//  Created by developer on 15.02.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var listOfString = [String]()
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "TableViewCell"
    var selectedCellIndexPath: IndexPath?
    
    private var editingVC: EditViewController?
    private var creatingVC: EditViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        genDataForTable()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        // add in table longpress tap
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.addTarget(self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func genDataForTable() {
        for i in 0..<100 {
            listOfString.append("cell number \(i+1)")
        }
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.tableView)
            
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                selectedCellIndexPath = indexPath
                self.navigationController?.isNavigationBarHidden = false
                let textInCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
                
                guard let editCellVC = storyboard?.instantiateViewController(identifier: "CellViewController") as? EditViewController else {
                    return
                }
                
                editCellVC.delegate = self
                editCellVC.textFromCell = textInCell
                self.creatingVC = editCellVC
                self.navigationController?.pushViewController(editCellVC, animated: true)
            }
        }
    }
}

// method for delegate
extension ViewController: ChangeValueDelegate {
    func didChangeValue(_ sender: EditViewController, data: String) {
        guard let indexPath = selectedCellIndexPath else {
            return
        }
        switch sender {
        case self.editingVC:
            // replace data inside sell
            listOfString[indexPath.row] = data
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case self.creatingVC:
            // insert new cell
            listOfString.insert(data, at: indexPath.row + 1)
            let newindexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            tableView.insertRows(at: [newindexPath], with: .bottom)
            let refreshArray = Array(indexPath.row...listOfString.count - 1).map{IndexPath(row: $0, section: 0)}
            tableView.reloadRows(at: refreshArray, with: .bottom)
        default:
            return
        }
    }
}

extension ViewController: UITableViewDelegate {
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndexPath = indexPath
        self.navigationController?.isNavigationBarHidden = false
        let textInCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        guard let editCellVC = storyboard?.instantiateViewController(identifier: "CellViewController") as? EditViewController else {
            return
        }
        
        editCellVC.delegate = self
        editCellVC.textFromCell = textInCell
        self.editingVC = editCellVC
        self.navigationController?.pushViewController(editCellVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    // get number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfString.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = listOfString[indexPath.row]
        
        cell.textLabel?.textColor = (indexPath.row % 2 == 1) ? .red : .black
        cell.textLabel?.isHidden = (indexPath.row % 5 == 4)
        
        return cell
    }
    
    // delete a cell in table through swipe to the left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listOfString.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            let refreshArray = Array(indexPath.row...listOfString.count - 1).map{IndexPath(row: $0, section: 0)}
            tableView.reloadRows(at: refreshArray, with: .bottom)
        }
    }
}

