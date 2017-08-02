//
//  SP_IM_TabCell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/28.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

enum SP_IM_TabCellClickButtonType {
    case tLogo
    case tImg
    case tText
    case tVoice
    case tChongFa
}
class SP_IM_TabCell_HeText: UITableViewCell {
    class func show(_ tableView:UITableView) -> SP_IM_TabCell_HeText {//, for: indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "SP_IM_TabCell_HeText") as! SP_IM_TabCell_HeText
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
    }
    
    @IBOutlet weak var btn_logo: UIButton!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var text_title: UITextView!
    @IBOutlet weak var btn_text: UIButton!
    
    var _block:((SP_IM_TabCellClickButtonType)->Void)?
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _block?(.tLogo)
        case btn_text:
            _block?(.tText)
        default:
            break
        }
    }
}
class SP_IM_TabCell_HeImg: UITableViewCell {
    class func show(_ tableView:UITableView) -> SP_IM_TabCell_HeImg {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SP_IM_TabCell_HeImg") as! SP_IM_TabCell_HeImg
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_Img.imageView?.contentMode = .scaleAspectFill
        //self.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
    }
    
    @IBOutlet weak var btn_logo: UIButton!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var btn_Img: UIButton!
    @IBOutlet weak var btn_play: UIButton!
    
    var _block:((SP_IM_TabCellClickButtonType)->Void)?
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _block?(.tLogo)
        case btn_Img:
            _block?(.tImg)
        default:
            break
        }
    }
}


class SP_IM_TabCell_MeText: UITableViewCell {
    class func show(_ tableView:UITableView) -> SP_IM_TabCell_MeText {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SP_IM_TabCell_MeText") as! SP_IM_TabCell_MeText
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityView.isHidden = true
        //self.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
    }
    
    @IBOutlet weak var btn_logo: UIButton!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var text_title: UITextView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var button_CF: UIButton!
    @IBOutlet weak var btn_text: UIButton!
    
    var isLoading:Bool = false {
        didSet{
            if isLoading {
                activityView.isHidden = false
                activityView.startAnimating()
            }else{
                activityView.isHidden = true
                activityView.stopAnimating()
            }
            
        }
    }
    var isSendFailure:Bool = false {
        didSet{
            if isSendFailure {
                isLoading = false
                button_CF.isHidden = !isSendFailure
            }
        }
    }
    
    
    var _block:((SP_IM_TabCellClickButtonType)->Void)?
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _block?(.tLogo)
        case btn_text:
            _block?(.tText)
        case button_CF:
            _block?(.tChongFa)
        default:
            break
        }
    }
}

class SP_IM_TabCell_MeImg: UITableViewCell {
    class func show(_ tableView:UITableView) -> SP_IM_TabCell_MeImg {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SP_IM_TabCell_MeImg") as! SP_IM_TabCell_MeImg
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btn_Img.imageView?.contentMode = .scaleAspectFill
        //self.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
    }
    
    @IBOutlet weak var btn_logo: UIButton!
    @IBOutlet weak var btn_Img: UIButton!
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var button_CF: UIButton!
    
    var isLoading:Bool = false {
        didSet{
            if isLoading {
                activityView.isHidden = false
                activityView.startAnimating()
            }else{
                activityView.isHidden = true
                activityView.stopAnimating()
            }
            
        }
    }
    var isSendFailure:Bool = false {
        didSet{
            if isSendFailure {
                isLoading = false
                button_CF.isHidden = !isSendFailure
            }
        }
    }
    
    var _block:((SP_IM_TabCellClickButtonType)->Void)?
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _block?(.tLogo)
        case btn_Img:
            _block?(.tImg)
        case button_CF:
            _block?(.tChongFa)
        default:
            break
        }
    }
}
class SP_IM_TabCell_MeVoice: UITableViewCell {
    class func show(_ tableView:UITableView) -> SP_IM_TabCell_MeVoice {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SP_IM_TabCell_MeVoice") as! SP_IM_TabCell_MeVoice
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        btn_Img.layer.borderColor = UIColor.main_line.cgColor
        btn_Img.layer.borderWidth = 0.5
        //self.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
        self.btn_Img.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
    }
    
    @IBOutlet weak var btn_logo: UIButton!
    @IBOutlet weak var btn_Img: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var btn_Img_W: NSLayoutConstraint!
    
    @IBOutlet weak var button_CF: UIButton!
    
    var isLoading:Bool = false {
        didSet{
            if isLoading {
                activityView.isHidden = false
                activityView.startAnimating()
            }else{
                activityView.isHidden = true
                activityView.stopAnimating()
            }
            
        }
    }
    var isSendFailure:Bool = false {
        didSet{
            if isSendFailure {
                isLoading = false
                button_CF.isHidden = !isSendFailure
            }
        }
    }
    
    var _block:((SP_IM_TabCellClickButtonType)->Void)?
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _block?(.tLogo)
        case btn_Img:
            _block?(.tVoice)
        case button_CF:
            _block?(.tChongFa)
        default:
            break
        }
    }
    
    func voicePlay() {
        /*
        UIImage *image = [YYImage imageNamed:@"ani.gif"];
        UIImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        [self.view addSubview:imageView];
         
         NSArray *paths = @[@"/ani/frame1.png", @"/ani/frame2.png", @"/ani/frame3.png"];
         NSArray *times = @[@0.1, @0.2, @0.1];
         UIImage *image = [YYFrameImage alloc] initWithImagePaths:paths frameDurations:times repeats:YES];
         UIImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
         [self.view addSubview:imageView];
         */
        
        
    }
    func voiceStop(){
        
    }
}

class SP_IM_TabCell_HeVoice: UITableViewCell {
    class func show(_ tableView:UITableView) -> SP_IM_TabCell_HeVoice {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SP_IM_TabCell_HeVoice") as! SP_IM_TabCell_HeVoice
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
        btn_Img.layer.borderColor = UIColor.main_line.cgColor
        btn_Img.layer.borderWidth = 0.5
        lab_time.textColor = UIColor.main_1
        lab_time.font = UIFont.systemFont(ofSize: 12)
    }
    
    @IBOutlet weak var btn_logo: UIButton!
    @IBOutlet weak var btn_Img: UIButton!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_time: UILabel!
    @IBOutlet weak var btn_Img_W: NSLayoutConstraint!
    
    var _block:((SP_IM_TabCellClickButtonType)->Void)?
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _block?(.tLogo)
        case btn_Img:
            _block?(.tVoice)
        default:
            break
        }
    }
    
    func voicePlay() {
        /*
         UIImage *image = [YYImage imageNamed:@"ani.gif"];
         UIImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
         [self.view addSubview:imageView];
         
         NSArray *paths = @[@"/ani/frame1.png", @"/ani/frame2.png", @"/ani/frame3.png"];
         NSArray *times = @[@0.1, @0.2, @0.1];
         UIImage *image = [YYFrameImage alloc] initWithImagePaths:paths frameDurations:times repeats:YES];
         UIImageView *imageView = [YYAnimatedImageView alloc] initWithImage:image];
         [self.view addSubview:imageView];
         */
        
        
    }
    func voiceStop(){
        
    }
}







