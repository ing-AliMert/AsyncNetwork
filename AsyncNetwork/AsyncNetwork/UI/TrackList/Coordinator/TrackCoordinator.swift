//
//  TrackCoordinator.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import UIKit
import SwiftUI

protocol TrackCoordinatorDelegate: AnyObject, Dismissable {
    func goToTrackDetail(item: Track)
    func goBack()
}

final class TrackCoordinator: CoordinatorProtocol, TrackCoordinatorDelegate {
    weak var parentCoordinator: ParentCoordinatorDelegate?
    var children: [CoordinatorProtocol] = []

    private let dependencies: DependencyContainer
    private let rootViewController: UINavigationController

    init(dependencies: DependencyContainer, rootViewController: UINavigationController) {
        self.dependencies = dependencies
        self.rootViewController = rootViewController
    }

    func start() {
        let trackService = TrackService(networkManager: dependencies.networkManager)
        let viewModel = TrackListViewModel(trackService: trackService)
        viewModel.coordinatorDelegate = self
        let viewController = TrackListViewController(viewModel: viewModel)
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func startSwiftUI() {
        let trackService = TrackService(networkManager: dependencies.networkManager)
        let viewModel = TrackListSwiftUIViewModel(trackService: trackService)
        viewModel.coordinatorDelegate = self

        let swiftUIView = TrackListSwiftUIView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: swiftUIView)
        
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func goToTrackDetail(item: Track) {
        let swiftUIView = TrackDetailSwiftUIView(track: item)
        let viewController = UIHostingController(rootView: swiftUIView)
        
        rootViewController.pushViewController(viewController, animated: true)
    }

    func goBack() {
        rootViewController.popViewController(animated: true)
    }
    
    deinit {
        print("'TrackCoordinator' is deinitialized\n")
    }
}
