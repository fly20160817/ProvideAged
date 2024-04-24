//
//  FLYZiGuangNetwork.h
//  ProvideAged
//
//  Created by fly on 2021/12/22.
//

#import <Foundation/Foundation.h>
#import "FLYZiGuangModel.h"
#import "FLYZiGuang.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYZiGuangNetwork : NSObject


#pragma mark - 自己平台的接口

/// 查询锁是否已经绑定
/// @param lockID 锁的id
/// @param successBlock 查询结果 (0未绑定 1已绑定)
/// @param failureBlock 查询失败
+ (void)getLockBindStatusNetwork:(NSString *)lockID success:(void(^)(NSInteger result))successBlock failure:(nullable void(^)(NSString * reason))failureBlock;


/// 获取锁的信息 （超管信息等)
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 回调锁的数据模型
/// @param failureBlock 失败的回调
+ (void)getLockInfoNetwork:(NSString *)lockID otherParams:(NSDictionary *)otherParams success:(void(^)(FLYZiGuangModel * lockModel))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 绑定门锁
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)bindDeviceNetwork:(NSString *)lockID otherParams:(nullable NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 解绑门锁
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)unboundDeviceNetwork:(NSString *)lockID otherParams:(nullable NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 添加开锁记录 (告诉我们的服务器开锁成功)
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addUnlockRecordNetwork:(NSString *)lockID otherParams:(nullable NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 添加指纹 (告诉我们的服务器添加指纹成功)
/// @param lockModel 锁的数据模型
/// @param userID 锁内的用户id
/// @param fingerprintNo 指纹编号
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addFingerPrintRecordNetwork:(FLYZiGuangModel *)lockModel userID:(NSString *)userID fingerprintNo:(NSString *)fingerprintNo otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 告诉我们的服务器删除指纹成功
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteFingerPrintRecordNetwork:(NSString *)lockID otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 告诉我们的服务器添加密码成功
/// @param lockModel 锁的数据模型
/// @param userID 锁内的用户id
/// @param password 密码
/// @param pwdNo 密码序号
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addPasswordRecordNetwork:(FLYZiGuangModel *)lockModel userID:(NSString *)userID password:(NSString *)password pwdNo:(NSString *)pwdNo otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 获取服务器生成的密码 (临时密码用)
/// @param lockModel 锁的数据模型
/// @param userID 锁内的用户id
/// @param pwdNo 密码序号
/// @param endTime 失效时间
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)getTempPasswordNetwork:(FLYZiGuangModel *)lockModel userID:(NSString *)userID pwdNo:(NSString *)pwdNo endTime:(NSInteger)endTime otherParams:(NSDictionary *)otherParams success:(void(^)(NSString * password))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 告诉我们的服务器删除密码成功
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deletePasswordRecordNetwork:(NSString *)lockID otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 告诉我们的服务器添加门卡成功
/// @param lockModel 锁的数据模型
/// @param userID 锁内的用户id
/// @param cardIndex 门卡序号
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addCardRecordNetwork:(FLYZiGuangModel *)lockModel userID:(NSString *)userID cardIndex:(NSString *)cardIndex otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 告诉我们的服务器添加临时门卡成功
/// @param lockModel 锁的数据模型
/// @param userID 锁内的用户id
/// @param cardIndex 门卡序号
/// @param endTime 失效时间
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addTempCardRecordNetwork:(FLYZiGuangModel *)lockModel userID:(NSString *)userID cardIndex:(NSString *)cardIndex endTime:(NSInteger)endTime otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 告诉我们的服务器删除门卡成功
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteCardRecordNetwork:(NSString *)lockID otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;



#pragma mark - 厂家平台的接口

/// 上传锁信息到厂家平台
/// @param lockModel 锁的数据模型
/// @param authKey 鉴权密钥 (在第一次注册绑定门锁时，会从锁端拿到)
/// @param communicationType 通信类型
/// @param imei imei
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)uploadLockForManufactorNetwork:(FLYZiGuangModel *)lockModel authKey:(NSString *)authKey communicationType:(FLYCommunicationType)communicationType imei:(NSString *)imei success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 从厂家平台删除锁
/// @param lockModel 锁的数据模型
/// @param communicationType 通信类型
/// @param completeBlock 结果 (0删除失败 1删除成功)
+ (void)deleteLockForManufactorNetwork:(FLYZiGuangModel *)lockModel communicationType:(FLYCommunicationType)communicationType complete:(void(^)(NSInteger result))completeBlock;

@end

NS_ASSUME_NONNULL_END
