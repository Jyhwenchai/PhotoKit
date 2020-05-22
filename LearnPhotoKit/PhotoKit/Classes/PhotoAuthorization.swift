//
//  PhotoAuthorization.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/22.
//  Copyright © 2020 didong. All rights reserved.
//

import Foundation
import Photos

/// 获取访问图库权限
func photoAuthorization(_ success: @escaping ()->()) {
    // 1
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
        // 2
     success()
    case .restricted, .denied:
     print("Photo Auth restricted or denied")
    case .notDetermined:
        // 3
     PHPhotoLibrary.requestAuthorization { status in
         switch status {
         case .authorized:
             // 4
             DispatchQueue.main.async {
                 success()
             }
         case .restricted, .denied:
             print("Photo Auth restricted or denied")
         case .notDetermined: break
         default: break
         }
     }
    default: break
    }
}
