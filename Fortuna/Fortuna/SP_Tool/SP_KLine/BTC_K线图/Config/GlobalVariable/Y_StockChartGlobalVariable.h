//
//  Y_StockChartGlobalVariable.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_StockChartConstant.h"

/**
 *  K线图的宽度，默认20
 */
static CGFloat Y_StockChartKLineWidth = 2;

/**
 *  K线图的间隔，默认1
 */
static CGFloat Y_StockChartKLineGap = 1;


/**
 *  MainView的高度占比,默认为0.65
 */
static CGFloat Y_StockChartKLineMainViewRadioOpenMACD = 0.5;
static CGFloat Y_StockChartKLineMainViewRadioCloseMACD = 0.70;
static CGFloat Y_StockChartKLineMainViewRadio = 0.70;

/**
 *  VolumeView的高度占比,默认为0.28
 */
static CGFloat Y_StockChartKLineVolumeViewRadioOpenMACD = 0.2;
static CGFloat Y_StockChartKLineVolumeViewRadioCloseMACD = 0.30;
static CGFloat Y_StockChartKLineVolumeViewRadio = 0.30;


/**
 *  是否为EMA线
 */
static Y_StockChartTargetLineStatus Y_StockChartKLineIsEMALine = Y_StockChartTargetLineStatusCloseMA;



@interface Y_StockChartGlobalVariable : NSObject

/**
 *  K线图的宽度，默认20
 */
+(CGFloat)kLineWidth;

+(void)setkLineWith:(CGFloat)kLineWidth;

/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap;

+(void)setkLineGap:(CGFloat)kLineGap;

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRadio;
+ (void)setkLineMainViewRadio:(CGFloat)radio;

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRadio;
+ (void)setkLineVolumeViewRadio:(CGFloat)radio;


/**
 *  isEMA线
 */
+ (CGFloat)isEMALine;
+ (void)setisEMALine:(Y_StockChartTargetLineStatus)type;
@end
