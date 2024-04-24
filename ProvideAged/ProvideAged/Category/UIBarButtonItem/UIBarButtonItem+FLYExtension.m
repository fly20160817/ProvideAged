//
//  UIBarButtonItem+FLYExtension.m
//  ProvideAged
//
//  Created by fly on 2021/9/7.
//

#import "UIBarButtonItem+FLYExtension.h"
#import "UIImage+FLYExtension.h"

@implementation UIBarButtonItem (FLYExtension)

/// 文字按钮
/// @param title 文字
/// @param font 字体
/// @param titleColor 文字颜色
/// @param target 目标
/// @param action 事件
+ (instancetype)itemWithTitle:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    
    NSDictionary * attributes = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : titleColor };
    [barButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    
    return barButtonItem;
}

/// 图片按钮
/// @param imageName 图片名字
/// @param target 目标
/// @param action 事件
+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamedWithOriginal:imageName] style:UIBarButtonItemStylePlain target:target action:action];
    
    return barButtonItem;
}

/// 图片+文字
/// @param imageName 图片名字
/// @param title 文字
/// @param font 字体
/// @param titleColor 文字颜色
/// @param target 目标
/// @param action 事件
+ (instancetype)itemWithImageName:(NSString *)imageName title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    //文字和图片都间距默认为3
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 1.5, 0, -1.5);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -1.5, 0, 1.5);
    button.width += 1.5 * 2;
     
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
