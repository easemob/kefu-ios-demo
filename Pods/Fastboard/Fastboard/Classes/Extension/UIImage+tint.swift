//
//  UIImage+tint.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/29.
//

import UIKit

extension UIImage {
    @available(iOS 13.0, *)
    func dynamicDraw(_ color: UIColor,
                     backgroundColor: UIColor? = nil,
                     cornerRadius: CGFloat = 0,
                     backgroundEdgeInset: UIEdgeInsets = .zero,
                     traitCollection: UITraitCollection) -> UIImage {
        redraw(color.resolvedColor(with: traitCollection),
               backgroundColor: backgroundColor?.resolvedColor(with: traitCollection),
               cornerRadius: cornerRadius,
               backgroundEdgeInset: backgroundEdgeInset)
    }
    
    func redraw(_ color: UIColor,
                   backgroundColor: UIColor? = nil,
                   cornerRadius: CGFloat = 0,
                   backgroundEdgeInset: UIEdgeInsets = .zero) -> UIImage {
        let rect = CGRect(origin: .zero, size: self.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        var bg: UIImage?
        var alpha = CGFloat(0)
        backgroundColor?.getWhite(nil, alpha: &alpha)
        
        // Draw background
        if let bgColor = backgroundColor, alpha > 0 {
            context?.setFillColor(bgColor.cgColor)
            let bgRect = rect.inset(by: backgroundEdgeInset)
            let path = UIBezierPath(roundedRect: bgRect, cornerRadius: cornerRadius)
            path.fill()
            context?.fillPath()
            bg = UIGraphicsGetImageFromCurrentImageContext()
            context?.clear(rect)
        }
        // Draw icon
        draw(in: rect)
        color.set()
        UIRectFillUsingBlendMode(rect, .sourceAtop)
        let icon = UIGraphicsGetImageFromCurrentImageContext()
        context?.clear(rect)
        // Compose
        bg?.draw(in: rect)
        icon?.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!.withRenderingMode(.alwaysOriginal)
    }

}
