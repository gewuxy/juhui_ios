//
//  CCLTimeView.h
//  KlineChart
//
//  Created by Crisps on 16/9/28.
//  Copyright © 2016年 cclion.cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCLTimeAboveView.h"
#import "CCLTimeBelowView.h"
#import "CCLTimeShareData.h"
@interface CCLTimeView : UIView
@property (nonatomic, strong) CCLTimeShareData *shareData;

@property (nonatomic, strong) CCLTimeAboveView *aboveView;

@property (nonatomic, strong) CCLTimeBelowView *belowView;
- (instancetype)initWithFrame:(CGRect)frame andSecID:(NSString *)secID;

@end
