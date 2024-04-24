//
//  UIView+FLYExtension.m
//  ProvideAged
//
//  Created by fly on 2021/9/9.
//

#import "UIView+FLYExtension.h"

@implementation UIView (FLYExtension)

/// 移除所有子视图
- (void)removeAllSubviews
{
    for( UIView * subview in [self subviews] )
    {
        [subview removeFromSuperview];
    }
}


@end
