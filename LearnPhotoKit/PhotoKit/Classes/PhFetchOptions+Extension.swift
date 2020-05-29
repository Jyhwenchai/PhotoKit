//
//  PhFetchOptions+Extension.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/22.
//  Copyright © 2020 didong. All rights reserved.
//

import Foundation
import Photos

extension PHFetchOptions {
    static var ascendingOptions: PHFetchOptions {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        return option
    }
}
