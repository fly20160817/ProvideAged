//
//  FLYMyModel.h
//  ProvideAged
//
//  Created by fly on 2021/9/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYMyModel : NSObject


/// 图片名字
@property (nonatomic, strong) NSString * iconName;

/// 标题
@property (nonatomic, strong) NSString * title;

/// 子标题
@property (nonatomic, strong) NSString * sutitle;

/// 是否显示线
@property (nonatomic, assign) BOOL isLine;

/// 是否显示箭头
@property (nonatomic, assign) BOOL isArrow;

@end

NS_ASSUME_NONNULL_END
