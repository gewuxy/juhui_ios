//
//  AS_AddImageCell.swift
//  IEXBUY
//
//  Created by sifenzi on 16/6/30.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import UIKit

class AS_AddImageCell: UICollectionViewCell {

    
    
    class func dequeueReusableCell(_ collectionView: UICollectionView, indexPath:IndexPath) -> AS_AddImageCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AS_AddImageCell", for: indexPath) as! AS_AddImageCell
        return cell;
    }
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBAction func removeBtnClick(_ sender: AnyObject) {
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
