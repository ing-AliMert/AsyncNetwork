//
//  TrackListSwiftUIViewModel.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import SwiftUI
import Combine

protocol TrackListSwiftUIViewModelProtocol: ObservableObject {
    var tracks: [Track]? { get }
    
    func loadData()
    func asyncLoadData() async
    func goToTrackDetail(item: Track)
}

class TrackListSwiftUIViewModel: TrackListSwiftUIViewModelProtocol {

    weak var coordinatorDelegate: TrackCoordinatorDelegate? {
        didSet {
            coordinatorDelegate?.sink().store(in: &cancellables)
        }
    }
    
    @Published var tracks: [Track]?
    
    private var cancellables = Set<AnyCancellable>()
    private let trackService: TrackServiceProtocol
    
    init(trackService: TrackServiceProtocol) {
        self.trackService = trackService
    }

    func loadData() {
        Task { [weak self] in
            let request =  MostLovedTracksRequest()
            let tracks = try? await self?.trackService.fetchTracks(request: request)

            await MainActor.run { [weak self] in
                self?.tracks = tracks?.loved
            }
        }.store(in: &cancellables)
    }
    
    func asyncLoadData() async {
        let request =  MostLovedTracksRequest()
        let tracks = try? await trackService.fetchTracks(request: request)

        await MainActor.run { [weak self] in
            self?.tracks = tracks?.loved
        }
    }
    
    func goToTrackDetail(item: Track) {
        coordinatorDelegate?.goToTrackDetail(item: item)
    }
    
    deinit {
        print("'TrackListSwiftUIViewModel' is deinitialized")
    }
}
