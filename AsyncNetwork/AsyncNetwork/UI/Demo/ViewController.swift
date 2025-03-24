//
//  ViewController.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - ViewModel

    var viewModel: DemoViewModelProtocol!
    
    // MARK: - Init

    convenience init(viewModel: DemoViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        let button = UIButton(type: .roundedRect)
        button.setTitle("Go to Tracks", for: .normal)

        button.addTarget(self, action: #selector(goToTracks), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func goToTracks() {
        viewModel.goToTracks()
    }
    
}

