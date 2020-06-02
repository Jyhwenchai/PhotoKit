//
//  PhotoFilters.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/2.
//  Copyright © 2020 didong. All rights reserved.
//

import Foundation
import Photos

class PhotoFilter {
    
//    func filterAssetCollection() -> [PHAssetCollection] {
//
//    }
    
}


extension PHFetchResult where ObjectType == PHAssetCollection {
    func availableSmartAlbumCollection() -> [PHAssetCollection] {
        var indexs: [Int] = []
        enumerateObjects { collection, index, canceled in
            if showMediaTypeValues.contains(collection.assetCollectionSubtype.rawValue) {
                indexs.append(index)
            }
        }
        return objects(at: IndexSet(indexs))
    }
}

extension PHFetchResult where ObjectType == PHCollection {
    func availableUserAlbumCollection() -> [PHAssetCollection] {
        var indexs: [Int] = []
        enumerateObjects { collection, index, canceled in
            if let collection = collection as? PHAssetCollection,
                collection.estimatedAssetCount > 0 {
                indexs.append(index)
            }
        }
        return objects(at: IndexSet(indexs)) as! [PHAssetCollection]
    }
}
