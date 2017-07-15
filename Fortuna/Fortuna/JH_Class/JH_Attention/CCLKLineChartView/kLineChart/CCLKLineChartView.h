//
//  CCLLineChartView.h
//  KlineChart
//
//  Created by Crisps on 16/9/6.
//  Copyright © 2016年 cclion.cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCLKLineShareData.h"
#import "CCLKLineAboveView.h"
#import "CCLKLineBelowView.h"
/**
 K线类型
 */
typedef enum : NSUInteger {
    CCLKLineDay,
    CCLKLineWeek,
    CCLKLineMonth,
} CCLKLineType;


@interface CCLKLineChartView : UIView

@property (nonatomic, assign) CCLKLineType type;

@property (nonatomic, strong) CCLKLineShareData *shareData;

@property (nonatomic, strong) CCLKLineAboveView *aboveView;

@property (nonatomic, strong) CCLKLineBelowView *belowView;

- (instancetype)initWithFrame:(CGRect)frame secID:(NSString *)secID andtype:(CCLKLineType)type;

@end
