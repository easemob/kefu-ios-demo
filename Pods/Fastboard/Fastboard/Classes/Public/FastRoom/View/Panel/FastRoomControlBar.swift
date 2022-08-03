//
//  FastRoomControlBar.swift
//  Fastboard
//
//  Created by xuyunshi on 2021/12/30.
//

import UIKit

/// The ToolBar in fastboard
/// All the views inserted in this container should not update the button isHidden property
/// call 'updateButtonHide'
public class FastRoomControlBar: UIView {
    public enum NarrowStyle {
        case none
        case narrowMoreThan(count: Int)
    }
    
    public var narrowStyle = NarrowStyle.none {
        didSet {
            updateNarrowStatus()
        }
    }
    
    func updateNarrowStatus() {
        switch narrowStyle {
        case .none:
            if foldButton.superview != nil { foldButton.removeFromSuperview() }
            foldButton.isSelected = false
            applyNarrowCount(nil)
        case .narrowMoreThan(let count):
            if foldButton.superview == nil { addSubview(foldButton) }
            foldButton.isSelected = true
            applyNarrowCount(count)
        }
        layoutForSubItems()
    }
    
    var forceHideButtons: [UIButton] = []
    
    public
    func forceUpdate(button: UIButton, visible: Bool) {
        if !visible, !forceHideButtons.contains(button) {
            forceHideButtons.append(button)
        } else if visible, forceHideButtons.contains(button) {
            forceHideButtons.removeAll(where: { $0 == button })
        }
        updateNarrowStatus()
    }
    
    @objc
    public dynamic var itemWidth: CGFloat = 44 {
        didSet {
            // Update buttons constant
            invalidateIntrinsicContentSize()
        }
    }
    
    @objc
    public dynamic var borderWidth: CGFloat = 1 / UIScreen.main.scale {
        didSet {
            updateMask()
        }
    }
    
    @objc
    public dynamic var commonRadius: CGFloat = 10 {
        didSet {
            updateMask()
        }
    }
    
    @objc
    dynamic override var borderColor: UIColor? {
        get { nil }
        set {
            if #available(iOS 13.0, *) {
                self.layer.borderColor = newValue?.resolvedColor(with: self.traitCollection).cgColor
                self.borderLayer.fillColor = newValue?.resolvedColor(with: self.traitCollection).cgColor
                traitCollectionUpdateHandler = { [weak self] _ in
                    guard let self = self else { return }
                    self.layer.borderColor = newValue?.resolvedColor(with: self.traitCollection).cgColor
                    self.borderLayer.fillColor = newValue?.resolvedColor(with: self.traitCollection).cgColor
                }
            } else {
                layer.borderColor = newValue?.cgColor
                borderLayer.fillColor = newValue?.cgColor
            }
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        layoutForSubItems()
        if direction == .horizontal {
            let x = subviews.filter { !($0 is UIVisualEffectView) && !($0.isHidden)}.map { $0.frame }.map { $0.maxX }.max() ?? 0
            return .init(width: x, height: itemWidth)
        } else {
            let y = subviews.filter { !($0 is UIVisualEffectView) && !($0.isHidden)}.map { $0.frame }.map { $0.maxY }.max() ?? 0
            return .init(width: itemWidth, height: y)
        }
    }
    
    @objc
    public var direction: NSLayoutConstraint.Axis {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    @objc
    public var borderMask: CACornerMask {
        didSet {
            updateMask()
        }
    }
    
    public init(direction: NSLayoutConstraint.Axis, borderMask: CACornerMask, views: [UIView]) {
        self.direction = direction
        self.borderMask = borderMask
        super.init(frame: .zero)
        
        addSubview(effectView)
        views.forEach({
            addSubview($0)
        })
        updateMask()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func updateMask() {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.borderWidth = borderWidth
            layer.cornerRadius = commonRadius
            layer.maskedCorners = borderMask
        } else {
            layer.mask = cornerRadiusLayer
            if borderLayer.superlayer == nil {
                layer.addSublayer(borderLayer)
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    func layoutForSubItems() {
        let isHorizontal = direction == .horizontal
        var lastStart: CGFloat = 0
        
        // Rearrange foldButton index to last
        if subviews.contains(foldButton),
            subviews.last != foldButton {
            foldButton.removeFromSuperview()
            addSubview(foldButton)
        }
        
        subviews
            .filter { !($0 is UIVisualEffectView) && !$0.isHidden }
            .enumerated()
            .forEach { index, v in
                let itemValue: CGFloat
                if let label = v as? UILabel {
                    let i = label.intrinsicContentSize.width / 5
                    let roundedWidth = CGFloat(ceil(i) * 5)
                    itemValue = roundedWidth
                } else {
                    itemValue = itemWidth
                }
                v.frame = .init(x: isHorizontal ? lastStart : 0,
                                y: isHorizontal ? 0 : lastStart,
                                width: isHorizontal ? itemValue : itemWidth,
                                height: isHorizontal ? itemWidth : itemValue)
                lastStart = isHorizontal ? v.frame.maxX : v.frame.maxY
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutForSubItems()
        effectView.frame = bounds
        if #available(iOS 11.0, *) {

        } else {
            cornerRadiusLayer.frame = bounds
            var corner: UIRectCorner = []
            if borderMask.contains(.layerMinXMinYCorner) {
                corner.insert(.topLeft)
            }
            if borderMask.contains(.layerMaxXMinYCorner) {
                corner.insert(.topRight)
            }
            if borderMask.contains(.layerMinXMaxYCorner) {
                corner.insert(.bottomLeft)
            }
            if borderMask.contains(.layerMaxXMaxYCorner) {
                corner.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: .init(width: commonRadius, height: commonRadius))
            cornerRadiusLayer.path = path.cgPath
            
            borderLayer.frame = bounds
            let innerPath = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corner, cornerRadii: .init(width: commonRadius, height: commonRadius))
            path.append(innerPath)
            borderLayer.fillRule = .evenOdd
            borderLayer.path = path.cgPath
        }
    }
    
    // MARK: - Action
    func applyNarrowCount(_ count: Int?) {
        if let moreThanCount = count {
            subviews
                .compactMap { $0 as? UIButton }
                .filter { !self.forceHideButtons.contains($0) }
                .enumerated()
                .forEach { i in
                    // The last one can't be hide
                    if i.element === foldButton {
                        i.element.isHidden = false
                        return
                    }
                    i.element.isHidden = i.offset >= moreThanCount
                }
        } else {
            subviews
                .compactMap { $0 as? UIButton }
                .forEach { $0.isHidden = self.forceHideButtons.contains($0) }
        }
        layoutForSubItems()
        invalidateIntrinsicContentSize()
        UIView.animate(withDuration: 0.3) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    @objc func onClickScale(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let isNarrow = sender.isSelected
        if isNarrow {
            guard case let .narrowMoreThan(count: moreThanCount) = narrowStyle else { return }
            applyNarrowCount(moreThanCount)
        } else {
            applyNarrowCount(nil)
        }
    }
    
    // MARK: - Lazy
    lazy var borderLayer = CAShapeLayer()
    lazy var cornerRadiusLayer = CAShapeLayer()
    
    lazy var effectView: UIVisualEffectView = {
        let effect: UIBlurEffect = .init(style: .regular)
        return UIVisualEffectView(effect: effect)
    }()
    
    lazy var foldButton: UIButton = {
        let btn = UIButton(type: .custom)
        let downImage = UIImage.currentBundle(named: "small_arr_down")?.redraw(FastRoomPanelItemButton.appearance().iconNormalColor ?? .black)
        let upImage = UIImage.currentBundle(named: "small_arr_top")?.redraw(FastRoomPanelItemButton.appearance().iconNormalColor ?? .black)
        func updateIcon() {
            btn.setImage(upImage, for: .normal) // expand
            btn.setImage(downImage, for: .selected) // narrow
        }
        updateIcon()
        btn.traitCollectionUpdateHandler = { _ in
            updateIcon()
        }
        btn.addTarget(self, action: #selector(onClickScale), for: .touchUpInside)
        return btn
    }()
}
