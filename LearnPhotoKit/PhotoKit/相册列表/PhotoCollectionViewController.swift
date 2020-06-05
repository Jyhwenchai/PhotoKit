//
//  PhotoCollectionViewController.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/2.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"
private let spacing: CGFloat = 1.0

class PhotoCollectionViewController: UIViewController {

    var album: AlbumModel!
    var assets: PHFetchResult<PHAsset>!
    
    var singleSelectionIndex: Int?
    var mutableSelectionIndexes: [Int] = []
    
    var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        return view
    }()
    
    var toolBar: PhotoToolBar = PhotoToolBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // Register cell classes
        initNav()
        initView()
        setup()
        initAction()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        toolBar.frame = CGRect(x: 0, y: view.bounds.height - 55, width: view.bounds.width, height: 55)
    }

    func setup() {
        assets = album.assets
    }

    func initNav() {
        self.title = album.name
        navigationController?.navigationBar.tintColor = .orange
        let barItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(dimissAction))
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], for: .normal)
        
        let selectItem = UIBarButtonItem(title: "mutable", style: .plain, target: self, action: #selector(changeEditStyle))
        
        navigationItem.rightBarButtonItems = [selectItem, barItem]
    }
    
    func initView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        view.addSubview(toolBar)
    }
    
    // MARK: Action
    
    func initAction() {
        toolBar.originView.addTarget(self, action: #selector(showOriginPhotoAction), for: .touchUpInside)
    }
    
    @objc func changeEditStyle(_ sender: UIButton) {
        singleSelectionIndex = nil
        mutableSelectionIndexes = []
        collectionView.allowsMultipleSelection.toggle()
        navigationItem.rightBarButtonItems!.first?.title = collectionView.allowsMultipleSelection ? "single" : "mutable"
        collectionView.reloadData()
        
    }
    

    @objc func dimissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showOriginPhotoAction() {
        toolBar.originView.isSelected.toggle()
    }
    
    func updatePhotoSelectionState(for cell: PhotoCell, indexPath: IndexPath) {
        if collectionView.allowsMultipleSelection {
            if cell.isSelected {
                mutableSelectionIndexes.append(indexPath.item)
                cell.radioButton.textLabel.text = "\(mutableSelectionIndexes.count)"
            } else {
                mutableSelectionIndexes.removeAll { $0 == indexPath.item }
                cell.radioButton.textLabel.text = ""
                collectionView.reloadData()
            }
        } else {
            singleSelectionIndex = cell.isSelected ? indexPath.item : nil
            collectionView.reloadData()
        }
    }
    
    func updateToolBarState() {
        toolBar.isMultipleSelection = collectionView.allowsMultipleSelection
        toolBar.previewButton.isEnabled = mutableSelectionIndexes.count > 0
        toolBar.selectedNumbers = collectionView.allowsMultipleSelection
            ? mutableSelectionIndexes.count
            : (singleSelectionIndex == nil ? 0 : 1)
    }
    
    deinit {
        print("deinit")
    }

}

extension PhotoCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets != nil ? assets.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        // 获取单个资源
        let asset = assets[indexPath.row]
        
        if case PHAssetMediaType.video = asset.mediaType {
            let minute = Int(asset.duration / 60)
            let second = Int(asset.duration - Double(minute) * 60)
            cell.timeLabel.text = String(format: "%02d:%02d", minute, second)
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        } else {
            cell.timeLabel.text = nil
        }
        
        // request and populate image
        FetchPhotosManager.default.requestImage(for: asset, targetSize: cell.frame.size) { (image, _) in
            cell.imageView.image = image
        }
        
        if collectionView.allowsMultipleSelection {
            cell.disableAnimate = true
            cell.radioButton.style = .text
            cell.isSelected = mutableSelectionIndexes.contains(indexPath.item)
        } else {
            cell.disableAnimate = false
            cell.radioButton.style = .image
            cell.radioButton.imageView.image = UIImage(named: "icons8-checkmark18")
            if let singleSelectedIndex = singleSelectionIndex {
                cell.isSelected = singleSelectedIndex == indexPath.item
            }
        }
        
        let selectedIndex = mutableSelectionIndexes.firstIndex { $0 == indexPath.item }
        if let index = selectedIndex {
            cell.radioButton.textLabel.text = "\(index + 1)"
        } else {
            cell.radioButton.textLabel.text = ""
        }
        
        cell.selectedClosure = { [weak self] in
            guard let self = self else { return }
            self.updatePhotoSelectionState(for: cell, indexPath: indexPath)
            self.updateToolBarState()
        }
        
        return cell
    }
    
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width - spacing * 3) / 4, height: (view.bounds.width - spacing * 3) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    
    
    // Get select asset detail info
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let asset = fetchResult.object(at: indexPath.item)
//
//        _ = FetchPhotosManager.default.requestImageDetailInfo(for: asset) { [unowned self] (data, uti, orientation, info) in
//
//            if let info = info {
//                let isInCloud    = (info[PHImageResultIsInCloudKey] as? Bool) ?? false
//                let isDegraded   = (info[PHImageResultIsDegradedKey] as? Bool) ?? false
//                let requestID    = (info[PHImageResultRequestIDKey] as? Int) ?? 0
//                let _            = (info[PHImageCancelledKey] as? Bool) ?? false
//                let error        = info[PHImageErrorKey] as? NSError
//
//
//                if error == nil, let imageData = data {
//
//                    let imageInfo = ImageInfo(uti: uti, orientation: UIImage.Orientation(rawValue: Int(orientation.rawValue))!, size: imageData.count, isInCloud: isInCloud, isDegraded: isDegraded, requestID: requestID)
//
//                    let showImage = ImageDetailViewController()
//                    showImage.image = UIImage(data: imageData)
//                    showImage.imageInfo = imageInfo
//                    self.present(showImage, animated: true, completion: nil)
//                }
//
//            }
//
//        }
//    }
    
   
}
