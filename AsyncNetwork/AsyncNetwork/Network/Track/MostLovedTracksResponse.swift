//
//  MostLovedTracksResponse.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

struct MostLovedTracksResponse: Decodable {
    let loved: [Track]
}

struct Track: Decodable {
    let idTrack: String
    let idAlbum: String
    let idArtist: String
    let strTrack: String
    let strAlbum: String
    let strArtist: String
    let strGenre: String?
    let strDescription: String?
    let strTrackThumb: String?
}
