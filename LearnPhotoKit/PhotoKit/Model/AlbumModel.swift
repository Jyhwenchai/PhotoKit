//
//  AlbumModel.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/2.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit
import Photos

struct AlbumModel {
    
    enum AlbumType {
        case all
        case smart(Int)
        case userCreate(String)
    }
    
    var image: UIImage?
    var name: String
    var type: AlbumType
    var assets: PHFetchResult<PHAsset>
    
    var count: Int {
        return assets.count
    }
    
    init(image: UIImage? = nil, name: String, assets: PHFetchResult<PHAsset>, type: AlbumType) {
        self.image = image
        self.name = name
        self.assets = assets
        self.type = type
    }
    
}
