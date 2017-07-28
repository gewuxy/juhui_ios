//
//  Y_KLineView.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_KLineModel.h"
#import "Y_StockChartConstant.h"
#import "Y_KLineMainView.h"
@interface Y_KLineView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  主K线图
 */
@property (nonatomic, strong) Y_KLineMainView *kLineMainView;
/**
 *  第一个View的高所占比例
 */
@property (nonatomic, assign) CGFloat mainViewRatio;

/**
 *  第二个View(成交量)的高所占比例
 */
@property (nonatomic, assign) CGFloat volumeViewRatio;

/**
 *  数据
 */
@property(nonatomic, copy) NSArray<Y_KLineModel *> *kLineModels;

/**
 *  重绘
 */
- (void)reDraw;


/**
 *  K线类型
 */
@property (nonatomic, assign) Y_StockChartCenterViewType MainViewType;
/**
 *  是否为以日分割
 */
@property (nonatomic, assign) BOOL FiveDay;
/**
 *  Accessory指标种类
 */
@property (nonatomic, assign) Y_StockChartTargetLineStatus targetLineStatus;
@end
