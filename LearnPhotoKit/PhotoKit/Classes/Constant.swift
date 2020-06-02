//
//  Constant.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/2.
//  Copyright © 2020 didong. All rights reserved.
//

import Foundation
import Photos

var showMediaTypeValues: [Int] {
    
    var types: [Int] = []
    types.append(PHAssetCollectionSubtype.smartAlbumPanoramas.rawValue)
    types.append(PHAssetCollectionSubtype.smartAlbumVideos.rawValue)
    types.append(PHAssetCollectionSubtype.smartAlbumFavorites.rawValue)
    types.append(PHAssetCollectionSubtype.smartAlbumTimelapses.rawValue)
    types.append(PHAssetCollectionSubtype.smartAlbumRecentlyAdded.rawValue)
    types.append(PHAssetCollectionSubtype.smartAlbumBursts.rawValue)
    types.append(PHAssetCollectionSubtype.smartAlbumSlomoVideos.rawValue)
    types.append(PHAssetCollectionSubtype.smartAlbumSelfPortraits.rawValue)
    types.append(PHAssetCollectionSubtype.smartAlbumScreenshots.rawValue)
    if #available(iOS 10.2, *) {
        types.append(PHAssetCollectionSubtype.smartAlbumDepthEffect.rawValue)
    }
    if #available(iOS 10.3, *) {
        types.append(PHAssetCollectionSubtype.smartAlbumLivePhotos.rawValue)
    }
    if #available(iOS 11, *) {
        types.append(PHAssetCollectionSubtype.smartAlbumAnimated.rawValue)
        types.append(PHAssetCollectionSubtype.smartAlbumLongExposures.rawValue)
    }
    
    return types
}
