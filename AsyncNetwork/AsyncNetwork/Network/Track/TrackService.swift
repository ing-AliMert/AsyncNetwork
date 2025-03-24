//
//  TrackService.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

protocol TrackServiceProtocol: AnyObject {
    func fetchTracks(request: MostLovedTracksRequest) async throws -> MostLovedTracksResponse
    func fetchTracksWithDataTaskCompletionHandler(request: MostLovedTracksRequest) async throws -> MostLovedTracksResponse
}

final class TrackService: TrackServiceProtocol {

    private let networkManager: NetworkProtocol
        
    init(networkManager: NetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchTracks(request: MostLovedTracksRequest) async throws -> MostLovedTracksResponse {
        try await networkManager.call(
            request: request,
            endpoint: EndPoint.Track.mostLovedList,
            responseType: MostLovedTracksResponse.self
        )
    }
    
    func fetchTracksWithDataTaskCompletionHandler(request: MostLovedTracksRequest) async throws -> MostLovedTracksResponse {
        try await networkManager.callWithTaskCompletionHandler(
            request: request,
            endpoint: EndPoint.Track.mostLovedList,
            responseType: MostLovedTracksResponse.self
        )
    }
    
    deinit {
        print("TrackService deinitialized")
    }
}
