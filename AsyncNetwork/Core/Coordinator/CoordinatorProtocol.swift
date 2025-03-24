//
//  CoordinatorProtocol.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import UIKit

public protocol CoordinatorProtocol: Dismissable, ParentCoordinatorDelegate {

    var parentCoordinator: ParentCoordinatorDelegate? { get set }
    
    func start()
}

public protocol ParentCoordinatorDelegate: AnyObject {

    var children: [CoordinatorProtocol] { get set }
    
    func childDidFinish(coordinator: CoordinatorProtocol)
}

// MARK: - CoordinatorProtocol

public extension CoordinatorProtocol {
    
    func dismiss() {
        parentCoordinator?.childDidFinish(coordinator: self)
    }
}

// MARK: - ParentCoordinatorDelegate

public extension ParentCoordinatorDelegate {
    
    func childDidFinish(coordinator: CoordinatorProtocol) {
        children = children.filter {
            $0 !== coordinator
        }
    }
}
