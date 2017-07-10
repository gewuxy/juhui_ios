//
//  photoCollectionViewCell.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/6.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos
protocol PhotoCollectionViewCellDelegate: class {
    func eventSelectNumberChange(_ number: Int);
    
}
class photoCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var thumbnail: UIImageView!
	@IBOutlet weak var imageSelect: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
	weak var delegate: PhotoCollectionViewController?
    weak var eventDelegate: PhotoCollectionViewCellDelegate?
	
	var representedAssetIdentifier: String?
	var model : PHAsset?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.thumbnail.contentMode = .scaleAspectFill
		self.thumbnail.clipsToBounds = true
	}
    
    func updateSelected(_ select:Bool){
        self.selectButton.isSelected = select
        self.imageSelect.isHidden = !select
        
        if select {
            self.selectButton.setImage(nil, for: UIControlState())
        } else {
            self.selectButton.setImage(UIImage(named: "picture_unselect"), for: UIControlState())
        }
    }
	
	@IBAction func eventImageSelect(_ sender: UIButton) {
		if sender.isSelected {
			sender.isSelected = false
			self.imageSelect.isHidden = true
			sender.setImage(UIImage(named: "picture_unselect"), for: UIControlState())
			if delegate != nil {
				if let index = PhotoImage.instance.selectedImage.index(of: self.model!) {
					PhotoImage.instance.selectedImage.remove(at: index)
				}
                
                if self.eventDelegate != nil {
                    self.eventDelegate!.eventSelectNumberChange(PhotoImage.instance.selectedImage.count)
                }
			}
		} else {
			
			if delegate != nil {
				if PhotoImage.instance.selectedImage.count >= PhotoPickerController.imageMaxSelectedNum - PhotoPickerController.alreadySelectedImageNum {
					self.showSelectErrorDialog() ;
					return;
				} else {
					PhotoImage.instance.selectedImage.append(self.model!)
                    
                    if self.eventDelegate != nil {
                        self.eventDelegate!.eventSelectNumberChange(PhotoImage.instance.selectedImage.count)
                    }
				}
			}
			
			sender.isSelected = true
            self.imageSelect.isHidden = false
			sender.setImage(nil, for: UIControlState())
			self.imageSelect.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
			UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6, options: [UIViewAnimationOptions.curveEaseIn], animations: { [weak self]() -> Void in
					self?.imageSelect.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
				}, completion: nil)
		}
	}
	
	fileprivate func showSelectErrorDialog() {
		if self.delegate != nil {
            let less = PhotoPickerController.imageMaxSelectedNum - PhotoPickerController.alreadySelectedImageNum
            
            let range = PhotoPickerConfig.ErrorImageMaxSelect.range(of: "#")
            var error = PhotoPickerConfig.ErrorImageMaxSelect
            error.replaceSubrange(range!, with: String(less))
            
			let alert = UIAlertController.init(title: nil, message: error, preferredStyle: UIAlertControllerStyle.alert)
			let confirmAction = UIAlertAction(title: PhotoPickerConfig.ButtonConfirmTitle, style: .default, handler: nil)
			alert.addAction(confirmAction)
			self.delegate?.present(alert, animated: true, completion: nil)
		}
	}
}
