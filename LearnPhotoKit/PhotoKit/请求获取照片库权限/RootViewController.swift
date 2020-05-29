//
//  RootViewController.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/5/22.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    @IBOutlet weak var requestAuthorizationCell: UITableViewCell!
    @IBOutlet weak var albumsListCell: UITableViewCell!
    
    var sas: Suas? = Suas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestAuthorizationCell.tapGesture {
            photoAuthorization {
                print("Photo Auth successs.")
            }
        }
        
        albumsListCell.tapGesture { [unowned self] in
            let controller = PhotoAlbumsViewController()
            self.present(controller, animated: true, completion: nil)
        }
    }

    
}

extension UIView {
    
    private struct AssociatedKeys {
        static var ActionsName = "UITableViewCell_ActionsName"
    }
    
    private var actions: [Int: () -> ()] {
        get {
             let actions = objc_getAssociatedObject(self, &AssociatedKeys.ActionsName) as? [Int : ()->()]
                         return actions ?? [:]
        }
        set {
            objc_setAssociatedObject( self, &AssociatedKeys.ActionsName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func tapGesture(_ action: @escaping () -> ()) {
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(gesture)
        actions[tag] = action
    }
    
    @objc private func tapAction()  {
        if let action = actions[tag] {
            action()
        }
    }
    

}
