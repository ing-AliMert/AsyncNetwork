//
//  DemoCoordinator.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import UIKit

protocol DemoCoordinatorDelegate: AnyObject, Dismissable {
    func goToTracks()
    func goBack()
}

final class DemoCoordinator: CoordinatorProtocol, DemoCoordinatorDelegate {
    weak var parentCoordinator: ParentCoordinatorDelegate?
    var children: [CoordinatorProtocol] = []
    
    private let dependencies: DependencyContainer
    private let rootViewController: UINavigationController

    init(dependencies: DependencyContainer, rootViewController: UINavigationController) {
        self.dependencies = dependencies
        self.rootViewController = rootViewController
    }

    func start() {
        let viewModel = DemoViewModel()
        let controller = ViewController(viewModel: viewModel)
        viewModel.coordinatorDelegate = self

        rootViewController.pushViewController(controller, animated: true)
    }

    func goBack() {
        rootViewController.popViewController(animated: true)
    }

    func goToTracks() {
        let coordinator = TrackCoordinator(dependencies: dependencies, rootViewController: rootViewController)
        coordinator.parentCoordinator = self
        children.append(coordinator)

        coordinator.startSwiftUI()
    }
}
