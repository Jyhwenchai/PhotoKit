//
//  ImageListViewControllerCollectionViewController.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/22.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"

class ImageListViewController: UICollectionViewController {

    var fetchResult: PHFetchResult<PHAsset>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        photoAuthorization {
            self.fetchResult = FetchPhotosManager.default.fetchAssets()
            self.collectionView.reloadData()
        }
    }
    


    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchResult.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
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
