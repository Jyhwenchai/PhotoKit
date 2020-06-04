//
//  CircleButton.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/4.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class RadioButton: UIControl {

    
    /// * .text: `unSelected` state show `circleLayer`、`selected` state show `circleLayer`、`textLabel`、`backgroundView`
    ///
    /// * .image: `unSelected` state show `circleLayer`、`selected` state show `circleLayer`、`imageView`、`backgroundView`
    enum Style {
        case image
        case text
        case imageAndText
    }
    
    var backgroundView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.systemGreen
        view.isHidden = true
        return view
    }()
    
    
    lazy var circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1.2
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.black.withAlphaComponent(0.1).cgColor
        return layer
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "icons8-checkmark18")
        imageView.tintColor = UIColor.white
        imageView.contentMode = .center
        imageView.isHidden = true
        return imageView
    }()
    
    var padding: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var style: Style = .text
    
    var borderWidth: CGFloat = 1.2 {
        didSet {
            circleLayer.borderWidth = borderWidth
        }
    }
    
    var disableAnimate: Bool = false

    override var isSelected: Bool {
        didSet {
            backgroundView.isHidden = !isSelected
            if oldValue == isSelected { return }
            updateSelectionState()
            if isSelected {
                executeSelectedAnimation()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        layer.addSublayer(circleLayer)
        addSubview(backgroundView)
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = bounds.insetBy(dx: circleLayer.lineWidth + padding, dy: circleLayer.lineWidth + padding)
        circleLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: frame.width / 2.0).cgPath
        
        
        frame = bounds.insetBy(dx: padding, dy: padding)
        backgroundView.frame = frame
        backgroundView.layer.cornerRadius = frame.width / 2.0
        
        textLabel.frame = frame
        imageView.frame = frame
    }
    
    func updateSelectionState() {
        switch style {
        case .image:
            backgroundView.isHidden = !isSelected
            imageView.isHidden = !isSelected
        case .text:
            backgroundView.isHidden = !isSelected
            textLabel.isHidden = !isSelected
        case .imageAndText:
            backgroundView.isHidden = !isSelected
            imageView.isHidden = isSelected
            textLabel.isHidden = !isSelected
        }
    }
    
    func executeSelectedAnimation() {
        if disableAnimate { return }
        
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.duration = animation.settlingDuration
        animation.initialVelocity = 10
        animation.damping = 10
        animation.mass = 1.0
        animation.stiffness = 300
        animation.fromValue = 0.7
        animation.toValue = 1.0
        backgroundView.layer.add(animation, forKey: nil)
    }

}
