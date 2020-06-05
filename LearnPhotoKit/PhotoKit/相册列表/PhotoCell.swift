//
//  PhotoCell.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/4.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    var radioButton: RadioButton = {
        let button = RadioButton()
        button.padding = 8.0
        return button
    }()
    
    var selectedClosure: (() -> ())?
    
    var disableAnimate: Bool = false {
        didSet {
            radioButton.disableAnimate = disableAnimate
        }
    }
    
    
    override var isSelected: Bool {
        didSet {
            updateStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(radioButton)
        
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = UIColor.black
        self.backgroundView = backgroundView
        
        let selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView.backgroundColor = UIColor.black
        self.selectedBackgroundView = selectedBackgroundView
        
        radioButton.addTarget(self, action: #selector(radioAction), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        
        let size = timeLabel.sizeThatFits(CGSize.zero)
        
        timeLabel.frame = CGRect(x: bounds.width - size.width - 5, y: bounds.height - size.height - 5, width: size.width, height: size.height)
        
        let radioSize = CGSize(width: 40, height: 40)
        radioButton.frame = CGRect(x: bounds.width - radioSize.width,
                                   y: 0,
                                   width: radioSize.width,
                                   height: radioSize.height)
    }

    func updateStyle() {
        if isSelected {
            imageView.alpha = 0.5
            radioButton.isSelected = true
        } else {
            imageView.alpha = 1
            radioButton.isSelected = false
        }
    }
    
    @objc
    private func radioAction() {
        disableAnimate = isSelected
        isSelected.toggle()
        selectedClosure!()
    }
}
