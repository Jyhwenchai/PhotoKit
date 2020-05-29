//
//  ImageInfo.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/27.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

struct ImageInfo {
    var uti: String?
    var orientation: UIImage.Orientation
    var size: Int
    var isInCloud: Bool
    var isDegraded: Bool
    var requestID: Int
    
    
    var sizeDesc: String {
        let kb = Double(size / 1024)
        if kb > 1024 {
            return String(format: "%.2lfmb", kb / 1024)
        }
        return String(format: "%.2lfkb", kb)
    }
}
