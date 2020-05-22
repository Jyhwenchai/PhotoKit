//
//  ViewController.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/22.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        photoAuthorization()
        
    }

    private func photoAuthorization() {
        // 1
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // 2
         imageView.image = loadImage()
        case .restricted, .denied:
         print("Photo Auth restricted or denied")
        case .notDetermined:
            // 3
         PHPhotoLibrary.requestAuthorization { status in
             switch status {
             case .authorized:
                 // 4
                 DispatchQueue.main.async {
                     self.imageView.image = self.loadImage()
                 }
             case .restricted, .denied:
                 print("Photo Auth restricted or denied")
             case .notDetermined: break
             default:break
             }
         }
        default: break
        }
    }
    
    private func loadImage() -> UIImage? {
        // 1
        let manager = PHImageManager.default()
        // 2
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        // 1
        var image: UIImage? = nil
        // 2
        manager.requestImage(for: fetchResult.object(at: 0), targetSize: CGSize(width: 647, height: 375), contentMode: .aspectFill, options: requestOptions()) { img, err  in
            // 3
         guard let img = img else { return }
             image = img
        }
        return image

    }

    private func fetchOptions() -> PHFetchOptions {
        // 1
        let fetchOptions = PHFetchOptions()
        // 2
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOptions
    }
    
    private func requestOptions() -> PHImageRequestOptions {
        let requestOptions = PHImageRequestOptions()
        // 2
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        return requestOptions
    }
}



var deinitCallbackKey = "DEINITCALLBACK_SUAS"

// MARK: Registartion
class Suas: NSObject {
    
}

extension Suas {

    func onObjectDeinit(forObject object: NSObject,
                             callbackId: String,
                             callback: @escaping () -> ()) {
        let rem = Suas.deinitCallback(forObject: object)
        rem.callbacks.append(callback)
  }

  static fileprivate func deinitCallback(forObject object: NSObject) -> DeinitCallback {
    if let deinitCallback = objc_getAssociatedObject(object, &deinitCallbackKey) as? DeinitCallback {
        return deinitCallback
    } else {
      let rem = DeinitCallback()
      objc_setAssociatedObject(object, &deinitCallbackKey, rem, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      return rem
    }
  }
}

@objc fileprivate class DeinitCallback: NSObject {
  var callbacks: [() -> ()] = []

  deinit {
    callbacks.forEach({ $0() })
  }
}
//
//customView = UIView(frame: CGRect(x: 50, y: 100, width: 100, height: 100))
//customView?.backgroundColor = UIColor.green
//view.addSubview(customView!)
//
//customView?.tapGesture {
//    print("actions")
//}
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//    self.customView?.removeFromSuperview()
//    self.customView = nil
//    print("dfsdfs", self.customView)
//}
