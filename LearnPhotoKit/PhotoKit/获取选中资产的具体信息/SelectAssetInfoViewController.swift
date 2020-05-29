//
//  SelectAssetInfoViewController.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/27.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"

class SelectAssetInfoViewController: UIViewController {

    var fetchResult: PHFetchResult<PHAsset>!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        photoAuthorization {
            self.fetchResult = FetchPhotosManager.default.fetchAssets()
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: UICollectionViewDataSource
extension SelectAssetInfoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        // 获取单个资源
        let asset = fetchResult.object(at: indexPath.item)

        if case PHAssetMediaType.video = asset.mediaType {
            let minute = Int(asset.duration / 60)
            let second = Int(asset.duration - Double(minute) * 60)
            cell.timeLabel.text = String(format: "%02d:%02d", minute, second)
            cell.timeLabel.sizeToFit()
        } else {
            cell.timeLabel.text = nil
        }
        
        FetchPhotosManager.default.requestImage(for: asset, targetSize: cell.frame.size) { (image, _) in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    
}

extension SelectAssetInfoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width - 4) / 3, height: (view.bounds.width - 4) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // Get select asset detail info
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = fetchResult.object(at: indexPath.item)
        
        _ = FetchPhotosManager.default.requestImageDetailInfo(for: asset) { [unowned self] (data, uti, orientation, info) in
            
            if let info = info {
                let isInCloud    = (info[PHImageResultIsInCloudKey] as? Bool) ?? false
                let isDegraded   = (info[PHImageResultIsDegradedKey] as? Bool) ?? false
                let requestID    = (info[PHImageResultRequestIDKey] as? Int) ?? 0
                let _            = (info[PHImageCancelledKey] as? Bool) ?? false
                let error        = info[PHImageErrorKey] as? NSError
    
                
                if error == nil, let imageData = data {

                    let imageInfo = ImageInfo(uti: uti, orientation: UIImage.Orientation(rawValue: Int(orientation.rawValue))!, size: imageData.count, isInCloud: isInCloud, isDegraded: isDegraded, requestID: requestID)
                    
                    let showImage = ImageDetailViewController()
                    showImage.image = UIImage(data: imageData)
                    showImage.imageInfo = imageInfo
                    self.present(showImage, animated: true, completion: nil)
                }
                
            }
            
        }
    }
}
