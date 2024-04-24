//
//  FLYSegmentBarConfig.m
//  FLYSegmentBar
//
//  Created by fly on 2020/3/12.
//

#import "FLYSegmentBarConfig.h"

//把它的值设为负1，因为宽度不会设置为负，当设置indicator宽度的时候，发现为负1就用自动计算出来的值，不是负1就设置为调用者赋的值。
CGFloat const FLYSegmentBarIndicatorAutomaticWidth = -1;

@implementation FLYSegmentBarConfig

+ (instancetype)defaultConfig {
    
    FLYSegmentBarConfig *config = [[FLYSegmentBarConfig alloc] init];
    config.segmentBarBackColor = [UIColor whiteColor];
    config.itemNormalFont = [UIFont systemFontOfSize:15];
    config.itemSelectFont = [UIFont systemFontOfSize:15];
    config.itemNormalColor = [UIColor lightGrayColor];
    config.itemSelectColor = [UIColor redColor];
    config.itemSpaceWidth = 20;
    
    config.hiddenIndicator = NO;
    config.indicatorColor = [UIColor redColor];
    config.indicatorHeight = 2;
    config.indicatorWidth = FLYSegmentBarIndicatorAutomaticWidth;
    config.indicatorCornerRadius = 0;
    
    config.leftMargin = 0;
    config.rightMargin = 0;
    
    return config;
}


@end
