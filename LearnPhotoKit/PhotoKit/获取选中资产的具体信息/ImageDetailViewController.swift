//
//  ImageDetailViewController.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/27.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    var imageInfo: ImageInfo? {
        didSet {
            if let value = imageInfo {
                descLabel.text = "imageSize: \(value.sizeDesc)  |   "
                    + "UTI: \(value.uti ?? "")  |   "
                    + "requestID: \(value.requestID)    |   "
                    + "isInCloud: \(value.isInCloud ? "true" : "false") |   "
                    + "isDegraded: \(value.isDegraded)"
            }
        }
    }
    
    
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: view.bounds.size.width - 30),
            imageView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
        view.addSubview(descLabel)
        NSLayoutConstraint.activate([
            descLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: 15),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }

}
