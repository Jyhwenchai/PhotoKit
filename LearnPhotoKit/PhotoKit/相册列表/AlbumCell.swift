//
//  AlbumCell.swift
//  PhotoKit
//
//  Created by 蔡志文 on 2020/6/1.
//  Copyright © 2020 didong. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true;
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 215.0 / 255, green: 215.0 / 255, blue: 215.0 / 255, alpha: 1)
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       setup()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        imageView?.backgroundColor = UIColor(red: 215.0 / 255, green: 215.0 / 255, blue: 215.0 / 255, alpha: 1)
    }
    
    func setup() {
        tintColor = UIColor.orange
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        addSubview(separatorView)
        
        imageView?.contentMode = .center
        imageView?.backgroundColor = UIColor(red: 215.0 / 255, green: 215.0 / 255, blue: 215.0 / 255, alpha: 1)
        imageView?.image = UIImage(named: "placeholder20")
        imageView?.tintColor = UIColor(red: 139.0 / 255, green: 139.0 / 255, blue: 139.0 / 255, alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
        coverImageView.center = CGPoint(x: coverImageView.center.x, y: contentView.center.y)
        imageView?.frame = coverImageView.frame
        
        titleLabel.frame = CGRect(x: coverImageView.frame.maxY + 15, y: 0, width: 0, height: 0)
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: titleLabel.center.x, y: contentView.center.y)
        
        coverImageView.isHidden = coverImageView.image == nil
        
        imageView?.isHidden = !coverImageView.isHidden
        
        let cellHeight = 1.0 / UIScreen.main.scale
        
        separatorView.frame = CGRect(x: bounds.height, y: bounds.height - cellHeight, width: bounds.width, height: cellHeight)
        
    }
    
}
