//
//  PhotoManager.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/2.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit
import Photos

class PhotoManager {
    
    static let `default` = PhotoManager()
    
    private let imageManager = PHCachingImageManager()
    
    
    enum MediaType {
        case image
        case video
        case all
        
        var predicate: NSPredicate {
            switch self {
            case .image:
                return NSPredicate(format: "mediaType=%d", PHAssetMediaType.image.rawValue)
            case .video:
                return NSPredicate(format: "mediaType=%d", PHAssetMediaType.video.rawValue)
            case .all:
                return NSPredicate(format: "mediaType in (%d,%d)", PHAssetMediaType.image
                    .rawValue, PHAssetMediaType.video.rawValue)
            }
        }
        
    }
    
    /// fetch all assets
    /// - Returns: A fetch result that contains the requested PHAsset objects, or an empty fetch result if no objects match the request.
    func fetchAllAssets() -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(with: .ascendingOptions)
    }
    
    
    /// Retrieves assets with the specified media type.
    /// - Parameter mediaType: A media type.
    /// - Returns: A fetch result that contains the requested PHAsset objects, or an empty fetch result if no objects match the request.
    func fetchAssets(with mediaType: MediaType) -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        options.predicate = mediaType.predicate
        return PHAsset.fetchAssets(with: options)
    }
    
    
    /// Retrieves asset collection of smart album.
    /// - Returns: A fetch result that contains the requested PHAssetCollection objects, or an empty fetch result if no objects match the request.
    func fetchSmartAlbumCollection() -> PHFetchResult<PHAssetCollection> {
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        return fetchResult
    }
    
    /// Retrieves asset collection of user-create albums and folder.
    /// - Returns: - Returns: A fetch result that contains the requested PHCollection objects, or an empty fetch result if no objects match the request.
    func fetchUserAlbumCollection() -> PHFetchResult<PHCollection> {
        let fetchResult = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        return fetchResult
    }
    
    
    func requestImage(for asset: PHAsset, targetSize: CGSize = CGSize(width: 55, height: 55), options: PHImageRequestOptions? = nil, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        return imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: resultHandler)
    }
    
    func cancelRequest(_ requestID: Int) {
        imageManager.cancelImageRequest(PHImageRequestID(requestID))
    }
}
