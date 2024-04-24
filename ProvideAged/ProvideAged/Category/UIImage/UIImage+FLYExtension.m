//
//  UIImage+FLYExtension.m
//  FLYKit
//
//  Created by fly on 2021/8/27.
//

#import "UIImage+FLYExtension.h"

@implementation UIImage (FLYExtension)

/// 返回一个渲染模式为原始模式的image
/// @param name 图片名字
+ (UIImage *)imageNamedWithOriginal:(NSString *)name
{
    UIImage * image = [UIImage imageNamed:name];
    //返回一个渲染模式为不渲染的图片
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return image;
}


/// 根据颜色和大小，生成一张图片
/// @param color 颜色
/// @param size 大小
+ (UIImage *)imageWithColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [color set];
    
    UIRectFill(CGRectMake(0, 0, size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale));
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}



/// 拉伸image
/// @param capInsets 设置拉伸的范围
- (UIImage *)resizableImageStretchWithCapInsets:(UIEdgeInsets)capInsets
{
    UIImage * image = [self resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    
    return image;
}


@end
