//
//  SP_HtmlEdit.swift
//  Fortuna
//
//  Created by LCD on 2017/8/22.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import YYText
import YCXMenu
import RxCocoa
import RxSwift



class SP_RichTextEdit: SP_ParentVC {

    let disposeBag = DisposeBag()
    var _vcType = SP_RichTextEditType.t短评
    //MARK:--- 工具栏 ----------
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
    }
    fileprivate func makeNavigation() {
        self.n_view._title = sp_localized(_vcType.rawValue)
    }
    
}
extension SP_RichTextEdit {
    
    fileprivate func makeToolBar() {
        toolBar.tool_B.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self](isOK) in
                //self?.makeMenu()
            }).addDisposableTo(disposeBag)
    }
    fileprivate func makeMenu(){
        let menuItems = [
            YCXMenuItem.init(sp_localized("短评"), image: nil, tag: 0, userInfo: ["title":"短评"]),
            YCXMenuItem.init(sp_localized("长文"), image: nil, tag: 1, userInfo: ["title":"长文"]),
            YCXMenuItem.init(sp_localized("活动"), image: nil, tag: 2, userInfo: ["title":"活动"])]
        let point = toolBar.tool_B.convert(toolBar.tool_B.center, to: sp_MainWindow)
        let fromRect = CGRect(x: point.x, y: point.y, width: 0, height: 0)
        YCXMenu.setHasShadow(true)
        YCXMenu.setTintColor(UIColor.mainText_1)
        YCXMenu.setSelectedColor(UIColor.black)
        YCXMenu.show(in: sp_MainWindow, from: fromRect, menuItems: menuItems) { (index, item) in
            
        }
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
}

extension SP_RichTextEdit:YYTextViewDelegate {
    func textViewDidBeginEditing(_ textView: YYTextView) {
        
    }
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print_SP("range.location ==> \(range.location)")
        print_SP("text.characters.count ==> \(text.characters.count)")
        if textView == textViewTitle {
            if (range.location >= 30 || range.location + text.characters.count > 30) {
                return false
            }
            return true
        }
        return true
    }
}
