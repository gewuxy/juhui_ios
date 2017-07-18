//
//  Y-StockChartView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/30.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartView.h"


#import "Masonry.h"

#import "Y_StockChartGlobalVariable.h"
@interface Y_StockChartView() <Y_StockChartSegmentViewDelegate>


@end


@implementation Y_StockChartView

#pragma mark ---------- 主图 ----------
- (Y_KLineView *)kLineView
{
    if(!_kLineView)
    {
        _kLineView = [Y_KLineView new];
        [self addSubview:_kLineView];
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.top.equalTo(self);
            make.left.equalTo(self.segmentView.mas_right);
        }];
    }
    return _kLineView;
}
#pragma mark ---------- 选择 ----------
- (Y_StockChartSegmentView *)segmentView
{
    if(!_segmentView)
    {
        _segmentView = [Y_StockChartSegmentView new];
        _segmentView.delegate = self;
        [self addSubview:_segmentView];
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.top.equalTo(self);
            make.width.equalTo(@(Y_StockChartViewSegmentViewWidth));
        }];
    }
    return _segmentView;
}

- (void)setItemModels:(NSArray *)itemModels
{
    _itemModels = itemModels;
    if(itemModels)
    {
        NSMutableArray *items = [NSMutableArray array];
        for(Y_StockChartViewItemModel *item in itemModels)
        {
            [items addObject:item.title];
        }
        self.segmentView.items = items;
        Y_StockChartViewItemModel *firstModel = itemModels.firstObject;
        self.currentCenterViewType = firstModel.centerViewType;
    }
    if(self.dataSource)
    {
        self.segmentView.selectedIndex = 4;
    }
}

- (void)setDataSource:(id<Y_StockChartViewDataSource>)dataSource
{
    _dataSource = dataSource;
    if(self.itemModels)
    {
        self.segmentView.selectedIndex = 4;
    }
}
- (void)reloadData
{
    self.segmentView.selectedIndex = self.segmentView.selectedIndex;
}

#pragma mark - 代理方法

- (void)y_StockChartSegmentView:(Y_StockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index
{
    NSLog(@"y_StockChartSegmentView: index ==>%ld",index);
    self.currentIndex = index;
    if(index >= 100)
    {
        [Y_StockChartGlobalVariable setisEMALine:index];
//        if(index == Y_StockChartTargetLineStatusMA)
//        {
//            [Y_StockChartGlobalVariable setisEMALine:Y_StockChartTargetLineStatusMA];
//        } else {
//            [Y_StockChartGlobalVariable setisEMALine:Y_StockChartTargetLineStatusEMA];
//        }
        self.kLineView.targetLineStatus = index;
        [self.kLineView reDraw];
        [self bringSubviewToFront:self.segmentView];
    
    } else {
        if(self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)])
        {
            id stockData = [self.dataSource stockDatasWithIndex:index];
            
            if(!stockData)
            {
                return;
            }
            
            Y_StockChartViewItemModel *itemModel = self.itemModels[index];
            
            
            Y_StockChartCenterViewType type = itemModel.centerViewType;
            

            
            if(type != self.currentCenterViewType)
            {
                //移除当前View，设置新的View
                self.currentCenterViewType = type;
                switch (type) {
                    case Y_StockChartcenterViewTypeKline:
                    {
                        self.kLineView.hidden = NO;
                        //                    [self bringSubviewToFront:self.kLineView];
                        [self bringSubviewToFront:self.segmentView];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
            if(type == Y_StockChartcenterViewTypeOther)
            {
                
            } else {
                self.kLineView.kLineModels = (NSArray *)stockData;
                self.kLineView.MainViewType = type;
                [self.kLineView reDraw];
            }
            [self bringSubviewToFront:self.segmentView];
        }
    }

}

@end


/************************ItemModel类************************/
@implementation Y_StockChartViewItemModel

+ (instancetype)itemModelWithTitle:(NSString *)title type:(Y_StockChartCenterViewType)type
{
    Y_StockChartViewItemModel *itemModel = [Y_StockChartViewItemModel new];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}

@end
