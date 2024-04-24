//
//  FLYTools.h
//  FLYKit
//
//  Created by fly on 2021/8/11.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYTools : NSObject

/// 获取文字高度
/// @param text 文字内容
/// @param font 字体
/// @param width 宽度
+ (float)heightForText:(NSString *)text font:(UIFont *)font width:(float)width;


/// 获取文字宽度
/// @param text 文字内容
/// @param font 字体
/// @param height 高度
+ (float)widthForText:(NSString *)text font:(UIFont *)font height:(float)height;


/// 获取当前屏幕显示的ViewController
+ (UIViewController *)currentViewController;


/// 获取keyWindow
+ (UIWindow *)keyWindow;


/// 获取安全区
+ (UIEdgeInsets)safeAreaInsets;



@end

NS_ASSUME_NONNULL_END
