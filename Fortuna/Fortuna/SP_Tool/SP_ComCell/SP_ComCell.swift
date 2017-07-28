//
//  SP_ComCell.swift
//  carpark
//
//  Created by 刘才德 on 2017/2/11.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class SP_ComCell: UIView {

    class func show(_ images:(L:String,R:String), title:(L:String,R:String), hiddenLine:Bool = false, hiddenLabelLine:Bool = true) -> SP_ComCell {
        let view = (Bundle.main.loadNibNamed("SP_ComCell", owner: nil, options: nil)!.first as? SP_ComCell)!
        view.image_L.sp_ImageName(images.L, ph: false)
        view.image_R.sp_ImageName(images.R, ph: false)
        view.label_L.text = title.L
        view.label_R.text = title.R
        view.view_Line.isHidden = hiddenLine
        view.label_L_LineView.isHidden = hiddenLabelLine
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    //MARK:--- 更新UI
    /**
     - parameter labelL: 左标题相关
     - parameter labelR: 右标题相关
     - parameter imageW: 左右图标宽
     */
    
    func updateUI(labelL:(font:UIFont, color:UIColor) = (UIFont.systemFont(ofSize: 17),UIColor.maintext_pitchblack), labelR:(font:UIFont, color:UIColor) = (UIFont.systemFont(ofSize: 14),UIColor.maintext_darkgray), imageW:(L:CGFloat,R:CGFloat) = (17,17)){
        image_L_W.constant = imageW.L
        image_L_H.constant = imageW.L
        image_R_W.constant = imageW.R
        image_R_H.constant = imageW.R
        if imageW.L == 0 {
            label_L_ConstrL.constant = 0
        }
        if imageW.R == 0 {
            label_R_ConstrR.constant = 0
        }
        label_L.font = labelL.font
        label_L.textColor = labelL.color
        label_R.font = labelR.font
        label_R.textColor = labelR.color
    }
    
    var _tapBlock:(()->Void)?
    @IBOutlet weak var image_L: UIImageView!
    @IBOutlet weak var image_R: UIImageView!
    @IBOutlet weak var image_L_W: NSLayoutConstraint!
    @IBOutlet weak var image_L_H: NSLayoutConstraint!
    @IBOutlet weak var image_R_W: NSLayoutConstraint!
    @IBOutlet weak var image_R_H: NSLayoutConstraint!
    
    @IBOutlet weak var label_L: UILabel!
    @IBOutlet weak var label_R: UILabel!
    @IBOutlet weak var label_L_LineView: UIView!
    @IBOutlet weak var label_L_ConstrL: NSLayoutConstraint!
    @IBOutlet weak var label_R_ConstrR: NSLayoutConstraint!
    
    @IBOutlet weak var view_Line: UIView!
    
    @IBAction func viewTapClick(_ sender: UIButton) {
        self.backgroundColor = UIColor.main_bgHigh
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [weak self]_ in
            self?.backgroundColor = UIColor.white
        }
        _tapBlock?()
    }
    @IBAction func viewTapDown(_ sender: UIButton) {
        self.backgroundColor = UIColor.main_bgHigh
    }
    @IBAction func viewTapDragExit(_ sender: UIButton) {
        self.backgroundColor = UIColor.white
    }
    @IBAction func viewTapDragEnter(_ sender: UIButton) {
        self.backgroundColor = UIColor.main_bgHigh
    }
    @IBAction func viewTapUpOutside(_ sender: Any) {
        self.backgroundColor = UIColor.white
    }
    @IBAction func viewTapEditingDidBegin(_ sender: Any) {
        self.backgroundColor = UIColor.main_bgHigh
    }
    @IBAction func viewTapEditingDidend(_ sender: Any) {
        self.backgroundColor = UIColor.white
    }
    
    
    @IBAction func longPressClick(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            break
            //self.backgroundColor = UIColor.main_bgHigh
        case .ended:
            self.backgroundColor = UIColor.white
        default:
            break
        }
    }

}
