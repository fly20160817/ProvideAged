//
//  FLYTools.m
//  FLYKit
//
//  Created by fly on 2021/8/11.
//

#import "FLYTools.h"

@implementation FLYTools


/// 获取文字高度
/// @param text 文字内容
/// @param font 字体
/// @param width 宽度
+ (float)heightForText:(NSString *)text font:(UIFont *)font width:(float)width
{
    NSDictionary * attribute = @{ NSFontAttributeName: font };
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    //将一个float类型的小数去掉，然后进一，
    return ceilf(size.height);
}


/// 获取文字宽度
/// @param text 文字内容
/// @param font 字体
/// @param height 高度
+ (float)widthForText:(NSString *)text font:(UIFont *)font height:(float)height
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    //将一个float类型的小数去掉，然后进一，
    return ceilf(size.width);
}


/// 获取当前屏幕显示的ViewController
+ (UIViewController *)currentViewController
{
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;

    while ( YES )
    {
        if ( [vc isKindOfClass:[UITabBarController class]] )
        {
            vc = ((UITabBarController*)vc).selectedViewController;
        }

        if ( [vc isKindOfClass:[UINavigationController class]] )
        {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController)
        {
            vc = vc.presentedViewController;
        }
        else
        {
            break;
        }
    }
    
    return vc;
}


/// 获取keyWindow
+ (UIWindow *)keyWindow
{
    NSArray  *windows = [[UIApplication sharedApplication] windows];
    
    for ( UIWindow * window in windows )
    {
        if ( window.isKeyWindow )
        {
            return window;
        }
    }
    
    return nil;
}


/// 获取安全区
+ (UIEdgeInsets)safeAreaInsets
{
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    
    if (@available(iOS 11.0, *))
    {
        safeAreaInsets = [self keyWindow].safeAreaInsets;
    }
    
    return safeAreaInsets;
}

@end
