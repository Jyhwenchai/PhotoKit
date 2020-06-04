//
//  AlbumListViewController.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/2.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit
import Photos

class AlbumListViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlbumCell.self, forCellReuseIdentifier: "\(type(of: AlbumCell.self))")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var fetchResultSmart: PHFetchResult<PHAssetCollection>!
    var fetchResultUser: PHFetchResult<PHCollection>!
    var fetchResultAll: PHFetchResult<PHAsset>!
    
    var albums: [AlbumModel] = []
    var checkIndex: Int = 0
    
    var showEmptyAlbums = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initNav()
        initView()
        initAlbums()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         tableView.frame = view.bounds
    }
    
    func initNav() {
        self.title = "相册"
        navigationController?.navigationBar.tintColor = .orange
        let barItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(dimissAction))
        barItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orange], for: .normal)
        navigationItem.rightBarButtonItem = barItem
        
    }
    
    func initView() {
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
    }
    
    func initAlbums() {
        fetchResultAll = PhotoManager.default.fetchAllAssets()
        fetchResultSmart = PhotoManager.default.fetchSmartAlbumCollection()
        fetchResultUser = PhotoManager.default.fetchUserAlbumCollection()
        
        let all = AlbumModel(name: "所有照片", assets: fetchResultAll, type: .all)
        albums.append(all)
        
         let smartAlbums = fetchResultSmart.availableSmartAlbumCollection()
        for index in 0..<smartAlbums.count {
            let collection = smartAlbums[index]
            let fetchAssets = PHAsset.fetchAssets(in: collection, options: nil)
            if !showEmptyAlbums && fetchAssets.count == 0  {
                continue
            }
            let album = AlbumModel(name: collection.assetCollectionSubtype.localizedTitle,
                                   assets: fetchAssets,
                                   type: .smart(collection.assetCollectionSubtype.rawValue))
            self.albums.append(album)
        }
        
        let userAlbums = fetchResultUser.availableUserAlbumCollection()
        for index in 0..<userAlbums.count {
            let collection = userAlbums[index]
            let fetchAssets = PHAsset.fetchAssets(in: collection, options: nil)
            if !showEmptyAlbums && fetchAssets.count == 0  {
                continue
            }
            let album = AlbumModel(name: collection.localizedTitle ?? "未知",
                                   assets: fetchAssets,
                                   type: .smart(collection.assetCollectionSubtype.rawValue))
            self.albums.append(album)
        }
    }
    
    @objc func dimissAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension AlbumListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(type(of: AlbumCell.self))") as! AlbumCell
        cell.coverImageView.image = nil
        
        if cell.tag != 0 {
            PhotoManager.default.cancelRequest(cell.tag)
            cell.tag = 0
        }
        
        var album = albums[indexPath.row]
        cell.titleLabel.text = album.name + "（\(album.assets.count)）"
        cell.accessoryType = checkIndex == indexPath.row ? .checkmark : .none
        
        if let image = album.image {
            cell.coverImageView.image = image
        } else if album.assets.count > 0 {
            let id = PhotoManager.default.requestImage(for: album.assets.lastObject!) { image, info in
                cell.coverImageView.image = image
                album.image = image
                self.albums.remove(at: indexPath.row)
                self.albums.insert(album, at: indexPath.row)
            }
            cell.tag = Int(id)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        checkIndex = indexPath.row
        tableView.reloadData()
        
        let controller = PhotoCollectionViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.album = albums[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
        
    }
}
