//
//  FLYZiGuang.h
//  ProvideAged
//
//  Created by fly on 2021/12/22.
//

#import <Foundation/Foundation.h>
#import "FLYZiGuangModel.h"

NS_ASSUME_NONNULL_BEGIN

//通信类型
typedef NS_ENUM(NSInteger, FLYCommunicationType)
{
    FLYCommunicationTypeDirect = 0,  //直连 (wifi锁就是直连)
    FLYCommunicationTypeAEP = 1,     //AEP
};


@interface FLYZiGuang : NSObject

/// 连接锁
/// @param lockID 锁的id (格式：ICIN_59789c5d32d9)
/// @param successBlock 连接成功的回调
/// @param failureBlock 连接失败的回调
+ (void)connectionLockWithLockID:(NSString *)lockID success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock;


/// 读取锁的信息
/// @param lockID 锁的id
/// @param communicationType 通信类型
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)readLockWithLockID:(NSString *)lockID communicationType:(FLYCommunicationType)communicationType success:(void(^)(id result, NSString * NbIMEI))successBlock failure:(void(^)(id result))failureBlock;


/// 重置锁
/// @param lockModel 锁的数据模型（超管之类的信息）
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)resetLockWithLockModel:(FLYZiGuangModel *)lockModel success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock;


/// 注册锁
/// @param lockModel 锁的数据模型
/// @param communicationType 通信类型
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)registereLockWithLockModel:(FLYZiGuangModel *)lockModel communicationType:(FLYCommunicationType)communicationType success:(void(^)(id result, NSString *authKey))successBlock failure:(void(^)(id result))failureBlock;


/// 添加用户
/// @param lockModel 锁的数据模型
/// @param userID 要添加的用户ID
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addUserWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID success:(void(^)(id result, NSString *authCode))successBlock failure:(void(^)(id result))failureBlock;


/// 删除用户
/// @param lockModel 锁的数据模型
/// @param userID 要删除的用户ID
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteUserWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock;


/// 清除本地密钥 (删除用户、重置、鉴权错误 9 时需要清除本地密钥)
/// @param lockID 锁的id
/// @param userID 用户ID
+ (void)cleanUserKeyWithLockID:(NSString*)lockID withUserID:(NSString*)userID;



/// 开锁
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码 (添加用户时返回该鉴权码，除超管外，每个用户都对应一个鉴权码)
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)openLockWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock;


/// 设置WiFi
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param wifiName wifi名字
/// @param wifiPassword wifi密码
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)setupWifiWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode wifiName:(NSString *)wifiName wifiPassword:(NSString *)wifiPassword success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock;


/// 添加指纹
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param progressBlock 当前录入的次数（添加指纹需要多次按压，每次按压都会回调进度）
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addFingerPrintWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode progress:(void(^)(NSInteger progress))progressBlock success:(void(^)(id result, NSString *fingerprintNo))successBlock failure:(void(^)(id result))failureBlock;


/// 删除指纹
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param fingerprintNo 指纹编号
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteFingerPrintWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode fingerprintNo:(NSInteger)fingerprintNo success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock;


/// 添加密码
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param password 需要添加的密码
/// @param pwdNo 密码序号 (自己生成，同一个用户下的pwdNo必须唯一)
/// @param endTime 失效时间 (永久密码endTime就传0，时效密码就传结束时的秒级时间戳)
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addPasswordWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode password:(NSString *)password pwdNo:(NSInteger)pwdNo endTime:(NSInteger)endTime success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock;


/// 删除密码
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param pwdNo 密码序号
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deletePasswordWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode pwdNo:(NSInteger)pwdNo success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock;


/// 添加门卡
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param cardIndex 门卡序号(自己生成，同一个用户下的cardIndex必须唯一)
/// @param endTime 失效时间 (永久门卡endTime就传0，时效门卡就传结束时的秒级时间戳)
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addCardWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode cardIndex:(NSInteger)cardIndex endTime:(NSInteger)endTime success:(void(^)(id result, NSString *cardNo))successBlock failure:(void(^)(id result))failureBlock;


/// 删除门卡
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param cardIndex 门卡序号
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteCardWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode cardIndex:(NSInteger)cardIndex success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock;


/// 断开连接
+ (void)disconnect;


@end

NS_ASSUME_NONNULL_END
