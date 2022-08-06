//
//  UIViewExtension.swift
//  Learnalize
//
//  Created by Media Davarkhah on 5/7/1401 AP.
//

import UIKit
extension UIView {
    func customTBLTConstraint(top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, leading:NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, topConst: CGFloat? = 0, bottomConst: CGFloat? = 0, leadingConst: CGFloat? = 0,trailingConst: CGFloat? = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConst ?? 0).isActive = true
        }
        if let bottom = bottom {
            bottom.constraint(equalTo: bottomAnchor, constant: bottomConst ?? 0).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: leadingConst ?? 0).isActive = true
        }
        if let trailing = trailing {
            trailing.constraint(equalTo: trailingAnchor, constant: trailingConst ?? 0).isActive = true
        }
        
    }
    
    func customHeightWidthConstraint(height: CGFloat? = nil, width:CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    func customXYConstraint(x: NSLayoutXAxisAnchor? = nil, y: NSLayoutYAxisAnchor? = nil) {
        if let x = x {
            centerXAnchor.constraint(equalTo: x).isActive = true
        }
        if let y = y {
            centerYAnchor.constraint(equalTo: y).isActive = true
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
       layer.masksToBounds = false
       layer.shadowColor = color.cgColor
       layer.shadowOpacity = opacity
       layer.shadowOffset = offSet
       layer.shadowRadius = radius

       layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
       layer.shouldRasterize = true
       layer.rasterizationScale = scale ? UIScreen.main.scale : 1
     }
}

