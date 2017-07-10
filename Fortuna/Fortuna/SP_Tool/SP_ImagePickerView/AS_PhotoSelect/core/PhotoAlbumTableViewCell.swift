//
//  PhotoAlbumTableViewCell.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/6.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumNumber: UILabel!
    
    let imageSize: CGFloat = 80
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.selectedBackgroundView = bgView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func renderData(_ result:PHFetchResult<PHAsset>, label: String?){
        self.albumTitle.text = label
        self.albumNumber.text = String(result.count)
        
        if result.count > 0 {
            let retinaMultiplier = UIScreen.main.scale
            let realSize = self.imageSize * retinaMultiplier
            let size = CGSize(width: realSize, height: realSize)
            
            let imageOptions = PHImageRequestOptions()
            imageOptions.resizeMode = .exact
            
            PHImageManager.default().requestImage(for: result.firstObject!, targetSize: size, contentMode: .aspectFill, options: imageOptions, resultHandler: { [weak self](image, info) -> Void in
                self?.albumCover.image = image
            })
        }
    }
    

}
