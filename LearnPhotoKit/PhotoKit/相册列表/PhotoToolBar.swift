//
//  PhotoToolBar.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/4.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class PhotoToolBar: UIView {
    
    private var contentView = UIView()
    
    var previewButton: UIButton = {
        let button = UIButton()
        button.setTitle("预览", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 15)
        let value: CGFloat = 131.0 / 255
        button.setTitleColor(UIColor(red: value, green: value, blue: value, alpha: 1), for: .disabled)
        button.isEnabled = false
        return button
    }()
    
    var originView: OrignView = {
        let view = OrignView()
        return view
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        let value: CGFloat = 83.0 / 255
        let titleColor: CGFloat = 171.0 / 255
        button.backgroundColor = .systemGreen
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("发送", for: .normal)
        button.layer.cornerRadius = 5.0
        button.isHidden = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return button
    }()
    
    var placeholderButton: UIButton = {
        let button = UIButton()
        let value: CGFloat = 83.0 / 255
        let titleColor: CGFloat = 171.0 / 255
        button.backgroundColor = UIColor(red: value, green: value, blue: value, alpha: 1)
        button.setTitleColor(UIColor(red: titleColor, green: titleColor, blue: titleColor, alpha: 1), for: .normal)
        button.setTitle("发送", for: .normal)
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    
    private var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()
    
    var vibrancyView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: effect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        return vibrancyView
    }()
    
    var isMultipleSelection: Bool = false
    
    var selectedNumbers: Int = 0 {
        didSet {
            let text = isMultipleSelection ? "发送(\(selectedNumbers))" : "发送"
            sendButton.setTitle(text, for: .normal)
            sendButton.isHidden = selectedNumbers <= 0
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(blurView)
        addSubview(contentView)
        contentView.addSubview(previewButton)
        contentView.addSubview(originView)
        contentView.addSubview(placeholderButton)
        contentView.addSubview(sendButton)
        
        vibrancyView.contentView.addSubview(placeholderButton)
        blurView.contentView.addSubview(vibrancyView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.frame = bounds
        vibrancyView.frame = blurView.bounds
        
        contentView.frame = bounds
        
        var size = previewButton.sizeThatFits(.zero)
        previewButton.frame = CGRect(x: 0, y: 0, width: size.width, height: contentView.bounds.height)
        
        size = originView.sizeThatFits(.zero)
        originView.frame = CGRect(x: 0, y: 0, width: size.width, height: contentView.bounds.height)
        originView.center.x = contentView.center.x
        
        placeholderButton.frame = CGRect(x: bounds.width - 55 - 15, y: (contentView.bounds.height - 32) / 2.0, width: 55, height: 32)
        
        size = sendButton.sizeThatFits(.zero)
        size.height = 32
        sendButton.frame = CGRect(x: bounds.width - size.width - 15, y: (contentView.bounds.height - 32) / 2.0, width: size.width, height: size.height)

    }
    
}
