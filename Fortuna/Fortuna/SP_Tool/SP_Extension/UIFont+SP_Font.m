//
//  UIFont+SP_Font.m
//  Fortuna
//
//  Created by 刘才德 on 2017/6/20.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

#import "UIFont+SP_Font.h"
#import <objc/message.h>
@implementation UIFont (SP_Font)
+ (void)load {
    
    Method systimeFont = class_getClassMethod(self, @selector(systemFontOfSize:));
    
    Method qsh_systimeFont = class_getClassMethod(self, @selector(sp_systemFontOfSize:));
    // 交换方法
    method_exchangeImplementations(qsh_systimeFont, systimeFont);
    
}


+ (UIFont *)sp_systemFontOfSize:(CGFloat)pxSize{
    
    CGFloat pt = (pxSize/96)*72;
    
    NSLog(@"pt--%f",pt);
    
    UIFont *font = [UIFont sp_systemFontOfSize:pt];
    
    return font;
    
}


@end
