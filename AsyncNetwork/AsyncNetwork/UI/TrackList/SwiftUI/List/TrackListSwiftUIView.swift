//
//  TrackListView.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import SwiftUI
import Combine

struct TrackListSwiftUIView<VM>: View where VM: TrackListSwiftUIViewModelProtocol {

    @ObservedObject var viewModel: VM

    ///
    /// When navigating back view refreshes. That means onAppear methods will run again.
    /// To not call loadData this flag is used.
    /// - Alternative:
    /// instead of this approach, we can call loadData method in viewModel's init method
    ///
    @State private var isFirstTime = true

    var body: some View {
        Group {
            if let tracks = viewModel.tracks {
                List {
                    Section {
                        ForEach(Array(tracks.enumerated()), id: \.offset) { index, track in
                            Button {
                                viewModel.goToTrackDetail(item: track)
                            } label: {
                                HStack(spacing: 8) {
                                    // MARK: Image
                                    Group {
                                        if 
                                           let imageUrl = track.strTrackThumb,
                                           let url = URL(string: imageUrl) {
                                            CustomAsyncImage(url: url) {
                                                Color.gray.opacity(0.4)
                                            } image: { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                        } else {
                                            Color.gray.opacity(0.4)
                                        }
                                    }
                                    .frame(width:32, height: 32)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .shadow(radius: 3, y: 3)
                                    .offset(x: -8)
                                    Text(track.strTrack)
                                }
                                .foregroundColor(.primary)
                                .padding(.vertical, 8)
                            }
                        }
                    } header: {
                        Text("Top 50")
                    }
                }
                .navigationTitle("Most Loved Songs")
            } else {
                ProgressView("Loading...")
                    .progressViewStyle(.circular)
            }
        }
//        .onAppear {
//            guard isFirstTime else {
//                return
//            }
//            isFirstTime.toggle()
//            viewModel.loadData()
//        }
        .task {
            guard isFirstTime else {
                return
            }
            isFirstTime.toggle()
            await viewModel.asyncLoadData()
        }
    }
}

// MARK: - Preview

struct TrackListSwiftUIView_Previews: PreviewProvider {
    static private let dependencies = DependencyContainer(networkManager: NetworkManager())
    static private let trackService = TrackService(networkManager: dependencies.networkManager)
    static private let viewModel = TrackListSwiftUIViewModel(trackService: trackService)

    static var previews: some View {
        NavigationView {
            TrackListSwiftUIView(viewModel: viewModel)
        }
    }
}

