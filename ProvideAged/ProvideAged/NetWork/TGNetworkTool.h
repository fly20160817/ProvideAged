//
//  TGNetworkTool.h
//  FLYKit
//
//  Created by fly on 2021/10/9.
//

/**
 
 探鸽sdk相关接口专用的网络类
 
 */

#import <Foundation/Foundation.h>
#import "FLYNetwork.h"
#import <SVProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface TGNetworkTool : NSObject

#pragma mark - 简化API

/// get网络请求
/// @param path url地址
/// @param params 参数
/// @param success 请求成功回调
/// @param failure 请求失败回调
+ (void)getWithPath:(NSString *)path
            params:(NSDictionary *)params
            success:(SuccessBlock)success
            failure:(FailureBlock)failure;



#pragma mark - 完整API

/// get网络请求
/// @param path url地址
/// @param params 参数
/// @param loadingType loading类型
/// @param loadingTitle loading文字
/// @param isHandle 返回结果是否需要内部处理（YES 只返回200的情况，其他状态码或请求失败都show出错误信息；NO  任何状态都直接返回出来给外界处理，不show任何信息）
/// @param success 请求成功回调
/// @param failure 请求失败回调
+ (void)getWithPath:(NSString *)path
            params:(NSDictionary *)params
            loadingType:(FLYNetworkLoadingType)loadingType
            loadingTitle:(nullable NSString *)loadingTitle
            isHandle:(BOOL)isHandle
            success:(SuccessBlock)success
            failure:(FailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
