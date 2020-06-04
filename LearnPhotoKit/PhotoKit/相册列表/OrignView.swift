//
//  OrignView.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/4.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class OrignView: UIControl {

    var radioButton: RadioButton = {
        let button = RadioButton()
        button.disableAnimate = true
        button.borderWidth = 1.0
        button.style = .image
        button.imageView.image = UIImage(named: "icons8-checkmark12")
        button.isUserInteractionEnabled = false
        return button
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = "原图"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(radioButton)
        addSubview(textLabel)
    }
    
    override var isSelected: Bool {
        didSet {
            radioButton.isSelected = isSelected
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        radioButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        radioButton.center.y = center.y - frame.minY
        
        textLabel.frame = CGRect(x: radioButton.frame.maxX + 5, y: 0, width: 0, height: 0)
        textLabel.sizeToFit()
        textLabel.center.y = center.y - frame.minY
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let textSize = textLabel.sizeThatFits(.zero)
        return CGSize(width: textSize.width + 5 + 16, height: max(textSize.height, 16))
    }
}
