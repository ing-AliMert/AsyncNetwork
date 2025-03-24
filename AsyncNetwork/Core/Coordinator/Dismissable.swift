//
//  Dismissable.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import Combine

public protocol Dismissable {

     func dismiss()
}

public extension Dismissable {

    func sink() -> AnyCancellable {
        AnyCancellable(dismiss)
   }
}
