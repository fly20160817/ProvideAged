//
//  UIView+FLYLayoutConstraint.m
//  FLYKit
//
//  Created by fly on 2021/5/12.
//

#import "UIView+FLYLayoutConstraint.h"

@implementation UIView (FLYLayoutConstraint)

/** 拥抱优先 (设置谁，谁变胖) */
-(void)huggingPriority
{
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
}

/** 压缩优先 (设置谁，谁显示的文字多) */
-(void)compressionResistancePriority
{
    [self setContentCompressionResistancePriority: UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

@end
