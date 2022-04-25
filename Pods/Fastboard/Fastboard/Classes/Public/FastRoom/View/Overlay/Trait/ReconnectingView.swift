//
//  ReconnectingView.swift
//  Fastboard
//
//  Created by xuyunshi on 2022/1/18.
//

import UIKit

class ReconnectingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var activityView: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .large)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()
}
