//
//  FLYZiGuangManager.h
//  ProvideAged
//
//  Created by fly on 2021/12/22.
//

/******************************************

一把锁可以添加100个用户，一个用户可以添加20个指纹。

因为我们自己后台的删除指纹接口，要传用户id，
后台一删就把这个用户的所有指纹都删了，
所以我们每添加一个指纹，都要创建一个新用户

因此，每次删指纹的时候，都要删掉用户，并且清掉该用户的缓存密钥，
不然添加100个指纹后，用户就满了。

 ******************************************/


#import <Foundation/Foundation.h>
#import "FLYZiGuang.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYZiGuangManager : NSObject


/// 绑定锁
/// @param lockID 门锁ID
/// @param communicationType 通信类型
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)bindLock:(NSString *)lockID communicationType:(FLYCommunicationType)communicationType otherParams:(nullable NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 解绑紫光锁
/// @param lockID 门锁ID
/// @param communicationType 通信类型
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)unboundLock:(NSString *)lockID communicationType:(FLYCommunicationType)communicationType otherParams:(nullable NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 开锁
/// @param lockID 门锁ID
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)openLock:(NSString *)lockID otherParams:(nullable NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 设置Wifi
/// @param lockID 紫光锁id
/// @param wifiName wifi名称
/// @param wifiPassword wifi密码
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)setupWifi:(NSString *)lockID wifiName:(NSString *)wifiName wifiPassword:(NSString *)wifiPassword otherParams:(nullable NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 添加指纹
/// @param lockID 门锁ID
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param progressBlock 当前录入的次数（添加指纹需要多次按压，每次按压都会回调进度）
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addFingerPrint:(NSString *)lockID otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect progress:(void(^)(NSInteger progress))progressBlock success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 删除指纹
/// @param lockID 门锁ID
/// @param userID 锁内的用户id(删除哪个用户下的指纹) (添加指纹的时候不用传，因为内部自动生成了一个用户id，并且上传了服务器；删除的时候服务器返回给我们，然后拿着这个用户id去删)
/// @param fingerprintNo 指纹编号
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteFingerPrint:(NSString *)lockID userID:(NSString *)userID fingerprintNo:(NSInteger)fingerprintNo otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 添加密码
/// @param lockID 门锁ID
/// @param password 需要添加的密码
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addPassword:(NSString *)lockID password:(NSString *)password otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 添加临时密码
/// @param lockID 门锁ID
/// @param endTime 失效时间 (秒级时间戳)
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addTempPassword:(NSString *)lockID endTime:(NSInteger)endTime otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 删除密码
/// @param lockID 门锁ID
/// @param userID 锁内的用户id(删除哪个用户下的密码)
/// @param pwdNo 密码序号
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deletePassword:(NSString *)lockID userID:(NSString *)userID pwdNo:(NSInteger)pwdNo otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 添加门卡
/// @param lockID 门锁ID
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addCard:(NSString *)lockID otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 添加临时门卡
/// @param lockID 门锁ID
/// @param endTime 失效时间 (秒级时间戳)
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addTempCard:(NSString *)lockID endTime:(NSInteger)endTime otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 删除门卡
/// @param lockID 门锁ID
/// @param userID 锁内的用户id(删除哪个用户下的门卡)
/// @param cardIndex 密码序号
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteCard:(NSString *)lockID userID:(NSString *)userID cardIndex:(NSInteger)cardIndex otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock;


/// 断开连接
+ (void)disconnect;

@end

NS_ASSUME_NONNULL_END
