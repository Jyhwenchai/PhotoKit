//
//  Album.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/1.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit
import Photos

struct Album {
    var coverImage: UIImage?
    var name: String
    var count: Int
    var asset: PHAsset?
    
    init(_ asset: PHAsset?, coverImage: UIImage?, name: String, count: Int = 0) {
        self.asset = asset
        self.coverImage = coverImage
        self.name = name
        self.count = count
    }
}


