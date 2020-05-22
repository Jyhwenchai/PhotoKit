//
//  SharePhotoLibraryViewController.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/22.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"

class SharePhotoLibraryViewController: UIViewController {

    var fetchResult: PHFetchResult<PHAsset>!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        /// 检索共享的照片库对象并进行注册，注册后可以监听照片库资产的变化以便可以对当前视图所展示的图像进行更新
        PHPhotoLibrary.shared().register(self)
        photoAuthorization {
            self.fetchResult = FetchPhotosManager.default.fetchAssets()
            self.collectionView.reloadData()
        }
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        PHPhotoLibrary.shared().performChanges({
            let image = UIColor.random.image()
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        })
    }
 
    deinit {
        /// 取消注册
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

}

// MARK: UICollectionViewDataSource
extension SharePhotoLibraryViewController: UICollectionViewDataSource {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         // #warning Incomplete implementation, return the number of items
         return fetchResult.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         // Configure the cell
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
         // 获取单个资源
         let asset = fetchResult.object(at: indexPath.item)
         
         FetchPhotosManager.default.requestImage(for: asset, targetSize: cell.frame.size) { (image, _) in
             cell.imageView.image = image
         }
         
         return cell
     }

}

/// 当照片库的资产发生改变时将调用此方法
extension SharePhotoLibraryViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        /// 对比图库中的资产集合与当前以获取的资产集和是否有区别，如果相同则返回 nil
        guard let changes = changeInstance.changeDetails(for: fetchResult) else { return }
        
        /// 获取最新图库资产集合
        self.fetchResult = changes.fetchResultAfterChanges
        
        DispatchQueue.main.async {
            
            /// 资产是否有发生变化，如果有则可以通过 `insertedIndexes`、`removedIndexes`、`changedIndexes` 等属性对 UI 进行一些刷新操作
            if changes.hasIncrementalChanges {
                self.collectionView?.performBatchUpdates({
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        self.collectionView?.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        self.collectionView?.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    
                    changes.enumerateMoves { fromIndex, toIndex in
                        self.collectionView?.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                             to: IndexPath(item: toIndex, section: 0))
                    }
                })
                
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    self.collectionView?.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                }
                
            } else {
                self.collectionView?.reloadData()
            }
        }
    }
    
    
}
