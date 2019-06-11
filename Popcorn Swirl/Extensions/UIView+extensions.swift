//
//  UIView+extensions.swift
//  Popcorn Swirl
//
//  Created by Carl Wainwright on 03/06/2019.
//  Copyright © 2019 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //round corners of a view, individually or all together
    func roundCorners(for corners: UIRectCorner, cornerRadius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    
    //creates a blur effect
    func blurView(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(blurView)
    }

    
}
