//
//  FetchPhotosManager.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/22.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit
import Photos

class FetchPhotosManager {
    
    static let `default` = FetchPhotosManager()
    
    let imageManager = PHCachingImageManager()
    
    func fetchAssets() -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(with: .ascendingOptions)
    }
 
    func requestImage(for asset: PHAsset, targetSize: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) {
        
        /// 通过指定的资产、大小等加载产生目标图像
        ///
        /// Parameter ：
        ///     asset: PHAsset - 资产
        ///     targetSize: CGSize - 目标尺寸
        ///     contentMode: PHImageContentMode - 产生图像所应用的模式
        ///     options：PHImageRequestOptions - 对产生的图片会产生影响的一些设置
        ///
        /// 对于这里”资产“，它可以是图片或视频，如果是视频那么图像请求提供的是缩略图或海报框。
        /// 默认该方法执行的是异步操作，如果在后自己的线程执行可以设置 `isSynchronous` 属性为 `true`
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil, resultHandler: resultHandler)
    }
}
