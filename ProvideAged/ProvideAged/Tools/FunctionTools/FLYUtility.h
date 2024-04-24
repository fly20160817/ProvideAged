//
//  FLYUtility.h
//  Elevator
//
//  Created by fly on 2016/12/26.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLYUtility.h"
@interface FLYUtility : NSObject

//此方法返回一张图片
+ (UIImage *) getImageWithColor:(UIColor*)color andSize:(CGSize)size;

//image图片设置圆角
+ (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original;

//view转Image
+(UIImage *)getImageFromView:(UIView *)view;


// Unicode转中文
+ (NSString*) replaceUnicode:(NSString*)TransformUnicodeString;

//把nil或null的字符串替换为replaceStr
+ (NSString *) filterNullAndNilWithString:(NSString *)str replaceStr:(NSString *)replaceStr;


//获取文字宽度
+ (float) widthForString:(NSString *)value font:(UIFont *)font andHeight:(float)height;

//获取文字高度
+ (float) heightForString:(NSString *)value font:(UIFont *)font andWidth:(float)width;


//解决拍照上传旋转90度问题
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

//获取当前屏幕显示的ViewController
+ (UIViewController *)currentViewController;

//计算两个经纬度之间的距离
+ (double)distanceBetweenOrderByLatitude1:(double)latitude1 longitude1:(double)longitude1 latitude2:(double)latitude2 longitude2:(double)longitude2;

/**
 * 比较版本号
 *
 * @param v1 当前版本号
 * @param v2 appStore版本号
 *
 * @return 如果版本号相等，返回 0,
 *         如果第一个版本号低于第二个，返回 -1，否则返回 1.
 */
+ (NSInteger)compareVersionWithCurrentVersion:(NSString *)v1 appStoreVersion:(NSString *)v2;


//获取当前时间的时间戳
+(NSString *)getNowTimeTimestamp;

//16进制转NSData
+ (NSData *)convertHexStrToData:(NSString *)str;

//NSData转16进制
+ (NSString *)convertDataToHexStr:(NSData *)data;

/**验证身份证号的合法性*/
+ (BOOL)checkUserID:(NSString *)userID;

/** 判断邮箱合法性 */
+ (BOOL)checkEmail:(NSString *)strEmail;

/** 获取安全区 */
+ (UIEdgeInsets)safeAreaInsets;

/// 获取keyWindow
+ (UIWindow *)keyWindow;

@end
