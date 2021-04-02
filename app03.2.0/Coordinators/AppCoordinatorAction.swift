//
//  AppCoordinatorAction.swift
//  app03.2.0
//
//  Created by developer on 04.03.2021.
//

import UIKit

protocol AppCoordinatorActionDelegateProtocol: class {
    func showEditScreeen(with data: String, isEditing: Bool, index: Int)
    func safeDataAndCloseEditScreen(with data: String, isEditing: Bool, index: Int)
}

protocol Coordinator: class {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private var baseViewModel: BaseViewModel?
    private var editViewModel: EditViewModel?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyBoard
                .instantiateViewController(identifier: "IDViewController") as? ViewController else { return }
        baseViewModel = BaseViewModel()
        baseViewModel?.viewDelegate = vc
        baseViewModel?.actionDelegate = self
        
        vc.viewModel = baseViewModel
        
        navigationController.pushViewController(vc, animated: true)
    }
}

extension MainCoordinator: AppCoordinatorActionDelegateProtocol {
    
    func showEditScreeen(with data: String, isEditing: Bool, index: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let editCellVC = storyBoard
                .instantiateViewController(identifier: "EditViewController") as? EditViewController else { return }
        
        editViewModel = EditViewModel(with: data, isEditing: isEditing, index: index)
        editViewModel?.actionDelegate = self
        
        editCellVC.viewModel = editViewModel
        
        navigationController.pushViewController(editCellVC, animated: true)
    }
    
    func safeDataAndCloseEditScreen(with data: String, isEditing: Bool, index: Int) {
        
        baseViewModel?.changeCellState(with: data, isEditing: isEditing, index: index)
        
        navigationController.popViewController(animated: true)
    }
}
