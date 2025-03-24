//
//  ImageLoader.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    
    @Published private(set) var image: UIImage?

    private let url: URL?
    private var task: URLSessionDataTask?

    init(url: URL?) {
        self.url = url
    }

    func load() {
        guard let url, image == nil else { return }

        let nsURL = url as NSURL
        if let cachedImage = ImageCache.shared.getImage(forKey: nsURL) {
            self.image = cachedImage
            return
        }

        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self,
                let data,
                let uiImage = UIImage(data: data),
                error == nil
            else { return }

            ImageCache.shared.setImage(uiImage, forKey: nsURL)
            DispatchQueue.main.async { [weak self] in
                self?.image = uiImage
            }
        }
        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }
}
