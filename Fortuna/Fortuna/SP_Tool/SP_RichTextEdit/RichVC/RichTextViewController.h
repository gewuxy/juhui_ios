//
//  RichTextViewController.h
//  RichTextView
//
//  Created by     songguolin on 16/1/7.
//  Copyright © 2016年 innos-campus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RichTextViewControllerDelegate <NSObject>

@optional
/**
 *  得到网页
 *
 *  @param imageArr   要上传的图片数组
 *  @param completion 传入urlArray 服务器返回的图片地址，返回网页NSString
 */
-(void)uploadImageArray:(NSArray *)imageArr withCompletion:(NSString * (^)(NSArray * urlArray))completion;

@end



typedef void (^inputFinished)(id  content,NSArray * imageArr);
typedef NSArray *(^uploadCompelte)(void);
typedef NSArray *(^atSelectCompelte)(void);
typedef NSArray *(^sharSelectCompelte)(void);
typedef NSArray *(^linkSelectCompelte)(void);

typedef NS_ENUM(NSUInteger,RichTextType) {
    RichTextType_PlainString=0,
    RichTextType_AttributedString,
    RichTextType_HtmlString,
};

IB_DESIGNABLE
@interface RichTextViewController : UIViewController

@property (weak,nonatomic) id<RichTextViewControllerDelegate>RTDelegate;

@property (weak, nonatomic) IBOutlet UIButton *btn_FaBu;
@property (weak, nonatomic) IBOutlet UILabel *lab_title;
@property (weak, nonatomic) IBOutlet UIButton *fontBtn;
@property (weak, nonatomic) IBOutlet UIButton *boldBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *atBtn;
@property (weak, nonatomic) IBOutlet UIButton *sharBtn;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;

//初始化页面
+(RichTextViewController*)initVC;
//提示字
@property (nonatomic,copy) IBInspectable NSString * placeholderText;
//文本类型
@property (nonatomic,assign) RichTextType textType;
//完成
@property (nonatomic,copy) inputFinished finished;
//编辑富文本，设置内容
@property (nonatomic,strong) id content;

//@
@property (nonatomic,copy) atSelectCompelte atSelect;
//#
@property (nonatomic,copy) sharSelectCompelte sharSelect;
//Link
@property (nonatomic,copy) linkSelectCompelte linkSelect;
@end
