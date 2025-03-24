//
//  UIView+Extensions.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import UIKit

extension UIView {
    
    func fit(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        if !subviews.contains(subview) {
            addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
