//
//  TrackListViewModel.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import Combine

/// Notes:
///  If `.store(in: &cancellables)` is not used after creating the Task, VM deinits but since the Task is not cancelled `TrackService` and `NetworkManager` does not deinits
///
final class TrackListViewModel: TrackListViewModelProtocol {
    
    weak var delegate: TrackListViewModelDelegate?
    weak var coordinatorDelegate: TrackCoordinatorDelegate? {
        didSet {
            coordinatorDelegate?.sink().store(in: &cancellables)
        }
    }

    private let trackService: TrackServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(trackService: TrackServiceProtocol) {
        self.trackService = trackService
    }

    func fetchTracks() {
        Task { [weak self] in
            do {
                let request = MostLovedTracksRequest()
                /// alternative method
//                 let response = try await self?.trackService.fetchTracksWithDataTaskCompletionHandler(request: request)
                let response = try await self?.trackService.fetchTracks(request: request)

                guard let self, let response else { return }

                await self.delegate?.didFetchTracks(response.loved)
            } catch {
                await self?.delegate?.didFailWithError(error)
            }
        }.store(in: &cancellables)
    }
    
    deinit {
        print("'TrackListViewModel' is deinitialized")
    }
}
