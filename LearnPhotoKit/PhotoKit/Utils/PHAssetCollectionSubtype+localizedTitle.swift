//
//  PHAssetCollectionSubtype+localizedTitle.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/29.
//  Copyright © 2020 didong. All rights reserved.
//

import Foundation
import Photos

extension PHAssetCollectionSubtype {
    var localizedTitle: String {
        switch self {
        case .smartAlbumPanoramas:      return "全景照片"
        case .smartAlbumVideos:         return "视频"
        case .smartAlbumFavorites:      return "个人收藏"
        case .smartAlbumTimelapses:     return "延时摄影"
        case .smartAlbumRecentlyAdded:  return "最近添加"
        case .smartAlbumBursts:         return "连拍快照"
        case .smartAlbumSlomoVideos:    return "慢动作"
        case .smartAlbumSelfPortraits:  return "自拍"         // 9.0+
        case .smartAlbumScreenshots:    return "屏幕快照"
        case .smartAlbumDepthEffect:    return "景深效果"
        case .smartAlbumLivePhotos:     return "Live Photo"   // 10.3+
        case .smartAlbumAnimated:       return "动图"
        case .smartAlbumLongExposures:  return "长曝光"
        default:                        return "未知"
        }
    }
}

