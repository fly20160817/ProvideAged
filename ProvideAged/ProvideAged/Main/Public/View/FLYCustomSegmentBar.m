//
//  FLYCustomSegmentBar.m
//  ProvideAged
//
//  Created by fly on 2021/9/8.
//

#import "FLYCustomSegmentBar.h"

@implementation FLYCustomSegmentBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        FLYSegmentBarConfig * tempConfig = [FLYSegmentBarConfig defaultConfig];
        tempConfig.segmentBarBackColor = [UIColor whiteColor];
        tempConfig.itemNormalColor = COLORHEX(@"#999999");
        tempConfig.itemSelectColor = COLORHEX(@"#333333");
        tempConfig.itemNormalFont = FONT_R(12);
        tempConfig.itemSelectFont = FONT_M(13);
        tempConfig.indicatorColor = COLORHEX(@"#2BB9A0");
        tempConfig.indicatorHeight = 1.5;
        tempConfig.indicatorWidth = 88;
        
        self.config = tempConfig;
        self.splitEqually = YES;
    }
    return self;
}

@end
