//
//  CustomAsyncImage.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import SwiftUI

///
/// Normally `AsyncImage` is only available in iOS 15+.
/// This custom AsyncImage will help us to use it in iOS 14.
///
struct CustomAsyncImage<Placeholder: View, ImageView: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let imageBuilder: (Image) -> ImageView

    init(
        url: URL?,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> ImageView = { $0 }
    ) {
        self.placeholder = placeholder()
        self.imageBuilder = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }

    private var content: some View {
        Group {
            if let uiImage = loader.image {
                imageBuilder(Image(uiImage: uiImage))
            } else {
                placeholder
            }
        }
    }
}
