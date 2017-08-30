//
//  SP_HtmlEdit.swift
//  Fortuna
//
//  Created by LCD on 2017/8/22.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import YYText
import RxCocoa
import RxSwift



class SP_RichTextEdit: SP_ParentVC {

    let disposeBag = DisposeBag()
    var _vcType = SP_RichTextEditType.t短评
    //MARK:--- 工具栏 ----------
    var toolBarConfi  = SP_RichTextEdit_ToolBarConfi()
    
    lazy var toolBar:SP_RichTextEditToolBar =  {
        let view = SP_RichTextEditToolBar.show()
        view.frame.size.height = 40
        view.view_Line.backgroundColor = UIColor.main_line
        return view
    }()
    //MARK:--- 编辑栏 ----------
    lazy var textViewTitle:YYTextView = {
        let text = YYTextView(frame: CGRect(x: 0, y: 64, width: sp_ScreenWidth, height: 70))
        text.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10)
        text.allowsCopyAttributedString = true;
        text.allowsPasteAttributedString = true;
        text.placeholderText = sp_localized("标题(最多30字)")
        text.delegate = self
        text.font = UIFont.boldSystemFont(ofSize: 20)
        text.placeholderFont = UIFont.boldSystemFont(ofSize: 20)
        text.showsVerticalScrollIndicator = false
        text.showsHorizontalScrollIndicator = false
        text.bounces = false
        return text
    }()
    
    lazy var textView:YYTextView = {
        let text = YYTextView()
        text.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        text.allowsCopyAttributedString = true;
        text.allowsPasteAttributedString = true;
        text.placeholderText = sp_localized("正文")
        text.font = UIFont.systemFont(ofSize: 16)
        text.placeholderFont = UIFont.systemFont(ofSize: 16)
        text.inputAccessoryView = self.toolBar
        text.delegate = self
        return text
    }()
    
    var dataTexts:[M_SP_RichText] = [M_SP_RichText()] {
        didSet{
            //self.makeTextContent()
        }
    }
    
    var locationStr:NSMutableAttributedString = NSMutableAttributedString()
    var isDelete = false //是否是回删
    var newRange:NSRange?
    var newstr = ""    //记录最新内容的字符串
}


extension SP_RichTextEdit {
    override class func initSPVC() -> SP_RichTextEdit {
        return UIStoryboard(name: "SP_RichTextEditStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SP_RichTextEdit") as! SP_RichTextEdit
    }
    class func show(_ pVC:UIViewController?, type:SP_RichTextEditType = .t短评) {
        let vc = SP_RichTextEdit.initSPVC()
        vc._vcType = type
        vc.hidesBottomBarWhenPushed = true
        pVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNavigation()
        self.makeToolBar()
        self.makeYYtextView()
        
        //testText()
    }
    fileprivate func makeNavigation() {
        self.n_view._title = sp_localized(_vcType.rawValue)
        self.n_view.n_btn_R1_Text = "发布"
    }
    override func clickN_btn_R1() {
        print_SP(self.textView.attributedText)
    }
    
}
extension SP_RichTextEdit {
    fileprivate func makeYYtextView() {
        
        switch _vcType {
        case .t长文:
            self.view.addSubview(textViewTitle)
            self.view.addSubview(textView)
            //下划线
            let lineView = UIView(frame: CGRect(x: 10, y: textViewTitle.frame.maxY+5, width: sp_ScreenWidth-20, height: 0.7))
            self.view.addSubview(lineView)
            lineView.backgroundColor = UIColor.main_line
            textView.frame = CGRect(x: 0, y: lineView.frame.maxY+5, width: sp_ScreenWidth, height: sp_ScreenHeight-lineView.frame.maxY-5)
        case .t短评:
            self.view.addSubview(textView)
            textView.frame = CGRect(x: 0, y: 64, width: sp_ScreenWidth, height: sp_ScreenHeight-64)
            
        }
        
    }
    func dataTextsAppendItem() {
        
        guard dataTexts.last!.isEdit else {
            
            return
        }
        dataTexts.append(M_SP_RichText())
    }
    
    func setInitLocation() {
        self.locationStr = NSMutableAttributedString(attributedString: self.textView.attributedText!)
        
    }
    //MARK:--- 设置样式 ----------
    func setStyle() {
        //把最新的内容进行替换
        self.setInitLocation()
        //是否回删
        if isDelete {return}
        
        
        var attributes:[String:Any] = [:]
        if toolBarConfi.isBold {
            attributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: toolBarConfi.fontSize)]
            
        }
        else
        {
            attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: toolBarConfi.fontSize)]
            
        }
        
        let replaceStr = NSAttributedString(string: self.newstr, attributes: attributes)
        self.locationStr.replaceCharacters(in: self.newRange!, with: replaceStr)
        
        textView.attributedText = self.locationStr
        
        //这里需要把光标的位置重新设定
        self.textView.selectedRange = NSMakeRange(self.newRange!.location+self.newRange!.length, 0)
        
    }
    
    fileprivate func makeTextContent() {
        let text:NSMutableAttributedString = NSMutableAttributedString()
        for item in dataTexts {
            switch item.type {
            case 0:
                var attributes:[String:Any] = [:]
                if item.isBold {
                    attributes = [NSFontAttributeName
                        :UIFont.boldSystemFont(ofSize: CGFloat(item.fontSize))]
                }else{
                    attributes = [NSFontAttributeName
                        :UIFont.systemFont(ofSize: CGFloat(item.fontSize))]
                }
                text.append(NSAttributedString(string: item.text, attributes: attributes))
            default:
                break
            }
        }
        
        textView.attributedText = text
    }
    
    fileprivate func testText() {
        
        var model0 = M_SP_RichText()
        model0.type = 0
        model0.text = "12345"
        
        var model1 = M_SP_RichText()
        model1.type = 0
        model1.text = "12345"
        model1.isBold = true
        
        var model2 = M_SP_RichText()
        model2.type = 0
        model2.text = "12345"
        model2.isBold = true
        model2.fontSize = 36
        
        dataTexts = [model0,model1,model2]
        
        makeTextContent()
    }
}

extension SP_RichTextEdit:YYTextViewDelegate {
    
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        switch textView{
        case textViewTitle:
            if (range.location >= 30 || range.location + text.characters.count > 30) {
                return false
            }else{
                return true
            }
        case textView:
            
            return true
        default:
            return true
        }
        
        
    }
    
    func textViewDidChange(_ textView: YYTextView) {
        
        let len = textView.attributedText!.length - self.locationStr.length
        print_SP("len => \(len)")
        if len > 0 {
            self.isDelete = false
            self.newRange = NSMakeRange(self.textView.selectedRange.location-len, len)
            self.newstr = textView.text.substring(with: self.textView.text.sp_range(from: self.newRange!)!)
        }else{
            self.isDelete = true
        }
        
        self.setStyle()
        
        /*
        //判断当前输入法是否是中文
        let isChinese = !(textView.textInputMode?.primaryLanguage == "en-US")
        //[[ self.textView text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
        if isChinese { //中文输入法下
            //获取高亮部分 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            let selectedRange = self.textView.markedTextRange
            if (selectedRange != nil) {
                let position = self.textView.position(from: selectedRange!.start, offset: 0)
                if (position != nil) {
                    
                }
            }
        }else{
            self.setStyle()
        }*/
    }
}
