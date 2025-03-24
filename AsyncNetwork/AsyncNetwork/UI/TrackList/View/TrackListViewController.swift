//
//  TrackListViewController.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import UIKit

final class TrackListViewController: UIViewController {

    // MARK: - ViewModel

    private var viewModel: TrackListViewModelProtocol!

    // MARK: - Views
    
    private let contentStack = UIStackView()
    
    // MARK: - Init

    convenience init(viewModel: TrackListViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        viewModel.fetchTracks()
    }
    
    // MARK: - UI

    private func prepareUI() {
        view.backgroundColor = .systemBackground
        let scrollView = UIScrollView()
        view.fit(subview: scrollView)
        
        contentStack.axis = .vertical
        contentStack.spacing = 16
        scrollView.fit(subview: contentStack)
        contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        let label = UILabel()
        label.text = "Loading..."
        label.textAlignment = .center
        contentStack.addArrangedSubview(label)
        label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    }

    deinit {
        print("'TrackListViewController' is deinitialized")
    }
}

// MARK: - TrackListViewModelDelegate

extension TrackListViewController: TrackListViewModelDelegate {
   
    func didFetchTracks(_ tracks: [Track]) {
        print("Tracks fetched: track count: \(tracks.count)\n")
        contentStack.clear()
        
        tracks.forEach { track in
            let label = UILabel()
            label.text = track.strTrack
            label.textAlignment = .center
            contentStack.addArrangedSubview(label)
        }
    }

    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}



