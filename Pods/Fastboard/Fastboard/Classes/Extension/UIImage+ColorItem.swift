//
//  UIImage+ColorItem.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/30.
//

import Foundation

extension UIImage {
    static func colorItemImage(withColor color: UIColor,
                               size: CGSize,
                               radius: CGFloat) -> UIImage? {
        let lineColor: CGColor = UIColor.black.withAlphaComponent(0.24).cgColor
        let lineWidth: CGFloat = 1
        let radius: CGFloat = radius
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let current = UIGraphicsGetCurrentContext()
        current?.setFillColor(color.cgColor)
        let pointRect = CGRect.init(origin: .zero, size: size)
        let bezeier = UIBezierPath(roundedRect: pointRect, cornerRadius: radius)
        current?.addPath(bezeier.cgPath)
        current?.fillPath()
        
        let strokeBezier = UIBezierPath(roundedRect: pointRect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2), cornerRadius: radius)
        current?.beginPath()
        current?.addPath(strokeBezier.cgPath)
        current?.setLineWidth(lineWidth)
        current?.setStrokeColor(lineColor)
        current?.strokePath()
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func selectedColorItemImage(withColor color: UIColor,
                               size: CGSize,
                               radius: CGFloat,
                               borderColor: UIColor) -> UIImage? {
        let selectedExpandMargin: CGFloat = 4
        let canvasSize = CGSize(width: size.width + selectedExpandMargin * 2, height: size.height + selectedExpandMargin * 2)
        
        let lineColor: CGColor = UIColor.black.withAlphaComponent(0.24).cgColor
        let lineWidth: CGFloat = 1
        let radius: CGFloat = radius
        
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, UIScreen.main.scale)
        let current = UIGraphicsGetCurrentContext()
        
        let selectedLineWidth = CGFloat(1)
        let selectedRect = CGRect(origin: .zero, size: canvasSize)
        let selectedLinePath = UIBezierPath(roundedRect: selectedRect.insetBy(dx: selectedLineWidth, dy: selectedLineWidth), cornerRadius: radius)
        current?.beginPath()
        current?.addPath(selectedLinePath.cgPath)
        current?.setLineWidth(selectedLineWidth)
        current?.setStrokeColor(borderColor.cgColor)
        current?.strokePath()
        
        current?.setFillColor(color.cgColor)
        let pointRect = CGRect.init(origin: .init(x: selectedExpandMargin, y: selectedExpandMargin), size: size)
        let bezier = UIBezierPath(roundedRect: pointRect, cornerRadius: radius)
        current?.addPath(bezier.cgPath)
        current?.fillPath()
        
        let strokeBezier = UIBezierPath(roundedRect: pointRect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2), cornerRadius: radius)
        current?.beginPath()
        current?.addPath(strokeBezier.cgPath)
        current?.setLineWidth(lineWidth)
        current?.setStrokeColor(lineColor)
        current?.strokePath()
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
