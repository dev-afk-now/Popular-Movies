//
//  UIViewGradient.swift
//  Popular Movies
//
//  Created by Никита Дубовик on 19.01.2022.
//

import UIKit

extension UIView {
    func makeGradient(colors: [UIColor],
                      startPoint: CGPoint,
                      endPoint: CGPoint) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.colors = colors.map {$0.cgColor}
        self.isUserInteractionEnabled = false
        self.layer.insertSublayer(gradient, at: 0)
    }
}
