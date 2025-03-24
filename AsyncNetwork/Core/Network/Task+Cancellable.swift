//
//  Task+Cancellable.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import Combine

extension Task {

    func store(in cancellables: inout Set<AnyCancellable>) {
        let cancellable = AnyCancellable {
            self.cancel()
        }
        cancellables.insert(cancellable)
    }
}
