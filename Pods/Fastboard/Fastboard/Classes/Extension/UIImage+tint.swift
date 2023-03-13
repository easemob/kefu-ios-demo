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
        let width = size.width - backgroundEdgeInset.left - backgroundEdgeInset.right
        let height = size.height - backgroundEdgeInset.top - backgroundEdgeInset.bottom
        let rect = CGRect(origin: .zero, size: .init(width: width, height: height))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        var bg: UIImage?
        var alpha = CGFloat(0)
        backgroundColor?.getWhite(nil, alpha: &alpha)
        
        // Draw background
        if let bgColor = backgroundColor, alpha > 0 {
            context?.setFillColor(bgColor.cgColor)
            let bgRect = rect
            let path = UIBezierPath(roundedRect: bgRect, cornerRadius: cornerRadius)
            path.fill()
            context?.fillPath()
            bg = UIGraphicsGetImageFromCurrentImageContext()
            context?.clear(rect)
        }
        
        // Draw icon
        let iconRect = CGRect(x: (rect.width - size.width) / 2, y: (rect.height - size.height) / 2, width: size.width, height: size.height)
        draw(in: iconRect)
        color.set()
        UIRectFillUsingBlendMode(iconRect, .sourceAtop)
        let icon = UIGraphicsGetImageFromCurrentImageContext()
        context?.clear(iconRect)
        
        // Compose
        bg?.draw(in: rect)
        icon?.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!.withRenderingMode(.alwaysOriginal)
    }

}
