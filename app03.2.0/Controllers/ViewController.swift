//
//  ViewController.swift
//  app03.2.0
//
//  Created by developer on 15.02.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "TableViewCell"
    
    weak var viewModel: BaseViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        // Add refreshControll (TableView has own refreshControl)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        // Add in table longpress tap
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.addTarget(self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        self.tableView.addGestureRecognizer(longPressGesture)
        
        viewModel?
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
    
    @objc func handleRefreshControl(sender: AnyObject) {
        viewModel?.genDataForTable(completion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        })
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            // get point in which we tap on cell
            let touchPoint = sender.location(in: self.tableView)
            // get indexPath of cell in tapping point
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {

                viewModel?.setIndex(indexPath.row)
                
                self.navigationController?.isNavigationBarHidden = false
                
                let textInCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
                
                viewModel?.didTapOnCell(with: textInCell ?? "", isEditing: false, index: indexPath.row)
            }
        }
    }
}

extension ViewController: BaseViewDelegateProtocol {
    
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
        let refreshArray = viewModel?.createArray(index: index).map{IndexPath(row: $0, section: 0)}
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: refreshArray!, with: .bottom)
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
        
        let countData = viewModel?.getListCount()
        if countData != 0 {
            DispatchQueue.main.async {
                self.tableView.isHidden = false
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel?.setIndex(indexPath.row)
        
        self.navigationController?.isNavigationBarHidden = false
        
        let textInCell = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        viewModel?.didTapOnCell(with: textInCell ?? "", isEditing: true, index: indexPath.row)
    }
}

extension ViewController: UITableViewDataSource {
    // get number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getListCount() ?? 0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = viewModel?.getListValue(index: indexPath.row)
        cell.textLabel?.textColor = viewModel?.getColor(index: indexPath.row)
        //cell.textLabel?.isHidden = (indexPath.row % 5 == 4)
        if indexPath.row % 5 == 4 {
            cell.textLabel?.textColor = UIColor.blue
        }
        
        return cell
    }
    
    // delete a cell in table through swipe to the left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.removeCellValue(index: indexPath.row)
        }
    }
}

