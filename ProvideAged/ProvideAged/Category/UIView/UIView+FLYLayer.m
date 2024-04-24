//
//  UIView+FLYLayer.m
//  FLYKit
//
//  Created by fly on 2021/8/13.
//

#import "UIView+FLYLayer.h"

@implementation UIView (FLYLayer)


/// 设置圆角
/// @param cornerRadius 圆角大小
- (void)roundCorner:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

/// 设置指定角的圆角 (设置完frame调用，或者在自动布局后面调用)
/// @param cornerRadius 圆角大小
/// @param rectCorner 哪些角
-(void)roundCorner:(CGFloat)cornerRadius rectCorners:(UIRectCorner)rectCorner
{
    [self layoutIfNeeded];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/// 设置边框
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
- (void)border:(CGFloat)borderWidth color:(UIColor *)borderColor
{
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
    self.layer.masksToBounds = YES;
}

/// 设置圆角和边框
/// @param cornerRadius 圆角大小
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
- (void)roundCorner:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = [borderColor CGColor];
    self.layer.masksToBounds = YES;
}

/// 设置指定角的圆角和边框 (设置完frame调用，或者在自动布局后面调用)
/// @param cornerRadius 圆角大小
/// @param rectCorner 哪些角
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
-(void)roundCorner:(CGFloat)cornerRadius rectCorners:(UIRectCorner)rectCorner borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    [self roundCorner:cornerRadius rectCorners:rectCorner];

    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    CAShapeLayer * borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    borderLayer.path = maskPath.CGPath;
    borderLayer.lineWidth = borderWidth;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    [self.layer addSublayer:borderLayer];
}

/// 设置阴影
/// @param shadowColor 阴影颜色
/// @param opacity 阴影透明度
/// @param radius 阴影半径(默认3)
/// @param offset 阴影偏移
-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset
{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
}


@end


