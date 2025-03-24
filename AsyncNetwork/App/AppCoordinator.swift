//
//  AppCoordinator.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024

import UIKit

final class AppCoordinator: CoordinatorProtocol {

    weak var parentCoordinator: ParentCoordinatorDelegate?
    var children: [CoordinatorProtocol] = []
    var rootViewController: UINavigationController!
    
    private let dependencies: DependencyContainer

    init(dependencies: DependencyContainer, rootViewController: UINavigationController) {
        self.dependencies = dependencies
        self.rootViewController = rootViewController
    }

    init(dependencies: DependencyContainer) {
        self.dependencies = dependencies
        self.rootViewController = UINavigationController()
        rootViewController.view.backgroundColor = .systemBackground
    }

    func start() {
        let coordinator = DemoCoordinator(dependencies: dependencies, rootViewController: rootViewController)
        coordinator.parentCoordinator = self
        children.append(coordinator)

        coordinator.start()
    }
}
