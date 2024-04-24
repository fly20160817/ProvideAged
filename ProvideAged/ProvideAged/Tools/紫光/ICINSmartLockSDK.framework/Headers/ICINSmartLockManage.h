//
//  ICINSmartLockManage.h
//  ICINSmartLockSDK
//
//  Created by TMC on 2020/9/14.
//  Copyright © 2020 ICIN. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN



typedef void (^connectionResults)(id result);

typedef void (^lockResults)(id result);



typedef NS_ENUM (NSInteger,LockOperationCode){
    LockOperationSuccessful = 00,//成功
    LockOperationInvalid = 0xff,//无效
    
};


@interface ICINSmartLockManage : NSObject

////

/// 程序启动时进行初始化
+(void)icin_initManage;

+(NSInteger)icin_BLEState;

//搜索附近门锁
+(void)icin_searchLockResult:(connectionResults)connectionResult;

/// 通过功能按钮获取门锁ID
/// @param connectionResult 结果
+(void)icin_functionButtonConnectionLockResult:(connectionResults)connectionResult;

/// 连接门锁
/// @param lockID 门锁ID
/// @param connectionResult 连接结果
+(void)icin_connectionLockID:(NSString*)lockID Result:(connectionResults) connectionResult;

/// 断开连接
+(void)icin_disconnect;


/// 首次绑定门锁时需要调用此接口，并将AuthKey进行保存
/// @param lockID 门锁ID
/// @param keyID 钥匙ID
/// @param superAdminId 超管ID
/// @param time 当前时间
/// @param NbIP NbIP
/// @param NbPort NbPort 
/// @param lockResult 结果
+(void)icin_registereSuperAdminLockID:(NSString*)lockID SuperAdminKeyID:(NSString*)keyID SuperAdminID:(NSString*)superAdminId Time:(NSInteger)time NBIP:(NSString*)NbIP NBPort: (NSString*)NbPort result:(lockResults) lockResult;

/// 添加管理员与普通用户
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param userID 用户ID
/// @param keyID 钥匙ID
/// @param role 用户角色 0普通用户 1管理员
/// @param authKey 鉴权密钥
/// @param lockResult  结果
+(void)icin_registereUserLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId UserID:(NSString*)userID UserKeyID:(NSString*)keyID Role:(NSInteger)role AuthKey:(NSString*) authKey result:(lockResults) lockResult;

///  删除用户
/// @param lockID 门锁ID
/// @param superAdminID 超管ID
/// @param userKeyID 钥匙ID
/// @param delUserID 被删除的用户ID
/// @param authKey 鉴权密钥
/// @param lockResult 结果

+(void)icin_deleteUserLockID:(NSString *)lockID SuperAdmindID:(NSString *)superAdminID UserKeyID:(NSString *)userKeyID DelUserID:(NSString *)delUserID AuthKey:(NSString *)authKey result:(lockResults) lockResult;

/// App开门
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param userID 用户ID
/// @param keyID 用户钥匙ID
/// @param openTime 开门时间
///
/// @param openModel 开门方式 0:正常，1:离线(openMode为0时，传递的time会校准门锁时间(此时间需准确)，
/// 若为1（例如无网络时），不会校准门锁时间。)
///
/// @param authCode 鉴权码
/// @param lockResult 结果
+(void)icin_openLockLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId UserID:(NSString*)userID KeyID:(NSString*)keyID OpenTime:(NSInteger)openTime OpenModel:(NSInteger)openModel AuthCode:(NSString*)authCode result:(lockResults) lockResult;


/// 门锁设置NB
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param userID 用户ID
/// @param keyID 用户KeyID
/// @param NBIP NBIP
/// @param NBPort NBPort
/// @param authCode 鉴权嘛
/// @param lockResult 结果
+(void)icin_requestNBLockRecordLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId UserID:(NSString*)userID UserKeyID:(NSString*)keyID NBIP:(NSString*)NBIP NBPort:(NSString*)NBPort AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 门锁同步时间
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param userID 用户ID
/// @param keyID 用户钥匙ID
/// @param time 当前时间
/// @param authCode 鉴权码
/// @param lockResult 结果
+(void)icin_synchronizationTimeLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId UserID:(NSString*)userID UserKeyID:(NSString*)keyID  Time:(NSInteger)time AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 门锁重置（超管才可使用）
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param keyID 超管钥匙ID
/// @param authKey 鉴权密钥
/// @param lockResult 结果
+(void)icin_resetLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId KeyID:(NSString*)keyID  AuthKey:(NSString*)authKey result:(lockResults) lockResult;


/// 固件升级
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param keyID 用户钥匙ID
/// @param userID 用户ID
/// @param fileVersion 固件版本号（服务器请求获取）
/// @param fiemwareData 固件（服务器请求获取）
/// @param authCode 鉴权码
/// @param lockResult 结果
+(void)icin_lockFirmwareUpgradeLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId UserKeyID:(NSString *)keyID UserID:(NSString*)userID FileVersion:(NSInteger)fileVersion FirmwareData:(NSData*)fiemwareData  AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 读取锁信息
/// @param lockID 门锁ID
/// @param lockResult 结果
+(void)icin_getLockMessageLockID:(NSString*)lockID result:(lockResults) lockResult;

/// 添加、删除密码
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param authUserID 授权用户ID
/// @param authUserkeyID 授权用户钥匙ID
/// @param userID  被添加的用户ID
/// @param pwdNo 密码序号
/// @param useCountLimit 密码使用次数 传入0为删除
/// @param pwd 密码
/// @param startTime 密码生效时间
/// @param endTime 密码失效时间
/// @param authCode 授权用户鉴权码
/// @param lockResult 结果
+(void)icin_managePassWordLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId AuthUserID:(NSString*)authUserID AuthUserkeyID:(NSString*)authUserkeyID UserID:(NSString*)userID PwdNo:(NSInteger)pwdNo UseCountLimit:(NSInteger)useCountLimit Pwd:(NSString *)pwd StartTime:(NSInteger)startTime EndTime:(NSInteger)endTime AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 查询密码
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param authUserID 授权用户ID
/// @param authUserkeyID 授权用户钥匙ID
/// @param userID 用户ID
/// @param authCode 授权用户鉴权码
/// @param lockResult 结果
+(void)icin_queryPassWordLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId AuthUserID:(NSString*)authUserID AuthUserKeyID:(NSString*)authUserkeyID UserID:(NSString*)userID  AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 添加指纹
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param authUserID 授权用户ID
/// @param authUserkeyID 授权用户钥匙ID
/// @param userID 用户ID
/// @param isAlarm 是否为胁迫指纹
/// @param authCode 鉴权码
/// @param lockResult 结果
+(void)icin_addFingerPrintLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId AuthUserID: (NSString*)authUserID AuthUserKeyID:(NSString*)authUserkeyID UserID:(NSString*)userID IsAlarm:(NSInteger)isAlarm  AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 查询指纹
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param authUserID 授权用户ID
/// @param authUserKeyID 授权用户钥匙ID
/// @param userID 用户ID
/// @param authCode 授权用户鉴权码
/// @param lockResult 结果
+(void)icin_queryFingerPrintLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId AuthUserID:(NSString*)authUserID AuthUserKeyID:(NSString*)authUserKeyID UserID:(NSString*)userID AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 删除指纹
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param authUserID 授权用户ID
/// @param authUserkeyID 授权用户钥匙ID
/// @param userID 要删除的用户ID
/// @param fingerprintNo 指纹编号
/// @param authCode 授权用户鉴权码
/// @param lockResult 结果
+(void)icin_deleteFingerPrintLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId AuthUserID:(NSString*)authUserID AuthuserKeyID:(NSString*)authUserkeyID UserID:(NSString*)userID FingerprintNo:(NSInteger) fingerprintNo  AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 删除门卡
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param authUserID 授权用户ID
/// @param authUserkeyID 授权用户钥匙ID
/// @param userID 要删除的用户ID
/// @param cardIndex 门卡序号
/// @param authCode 授权用户鉴权码
/// @param lockResult 结果
+(void)icin_deleteCardLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId AuthUserID:(NSString*)authUserID AuthuserKeyID:(NSString*)authUserkeyID UserID:(NSString*)userID CardIndex:(NSInteger)cardIndex  AuthCode:(NSString*)authCode result:(lockResults) lockResult;
/// 查询门卡
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param authUserID 授权用户ID
/// @param authUserKeyID 授权用户钥匙ID
/// @param userID 用户ID
/// @param authCode 授权用户鉴权码
/// @param lockResult 结果
+(void)icin_queryCardLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId AuthUserID:(NSString*)authUserID AuthUserKeyID:(NSString*)authUserKeyID UserID:(NSString*)userID AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 添加门卡
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param authUserID 授权用户ID
/// @param authUserkeyID 授权用户钥匙ID
/// @param userID 用户ID
/// @param cardIndex 门卡序号
/// @param authCode 鉴权码
/// @param lockResult 结果
+(void)icin_addCardLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId AuthUserID: (NSString*)authUserID AuthUserKeyID:(NSString*)authUserkeyID UserID:(NSString*)userID CardIndex:(NSInteger)cardIndex   AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 设置门锁音量
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param userID 用户ID
/// @param keyID 用户钥匙ID
/// @param muteFlag 0:静音，1:低音，2:高音
/// @param authCode 鉴权码
/// @param lockResult 结果
+(void)icin_setVolumeLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId UserID:(NSString*)userID KeyID:(NSString*)keyID MuteFlag:(NSInteger)muteFlag AuthCode:(NSString*)authCode result:(lockResults) lockResult;

/// 上传开锁记录
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param userID 用户ID
/// @param keyID 钥匙ID
/// @param authCode 鉴权码
/// @param lockResult 结果
+(void)icin_uploadLockRecordLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId UserID:(NSString*)userID KeyID:(NSString*)keyID AuthCode:(NSString*)authCode result:(lockResults) lockResult;
//读取门锁开锁记录
+(void)icin_firstUploadLockRecordLockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId UserID:(NSString*)userID KeyID:(NSString*)keyID AuthCode:(NSString*)authCode result:(lockResults) lockResult;
//读取门锁后边开锁记录
+(void)icin_nextUploadLockRecordResult:(lockResults) lockResult;
/// 清除App本地用户密钥
/// @param lockID 门锁ID
/// @param userID 用户ID
+(void)icin_cleanUserKeyLockID:(NSString *)lockID withUserID:(NSString *)userID;


/// 设置WI-FI
/// @param lockID 门锁ID
/// @param superAdminId 超管ID
/// @param userID 用户ID
/// @param keyID 钥匙ID
/// @param WIFISSID Wi-Fi名称
/// @param WiFipwd Wi-Fi密码
/// @param authCode 鉴权码
/// @param lockResult 结果
+(void)icin_setWIFILockID:(NSString*)lockID SuperAdminId:(NSString*)superAdminId UserID:(NSString*)userID KeyID:(NSString*)keyID WIFISSID:(NSString *)WIFISSID
    WiFiPwd:(NSString *)WiFipwd AuthCode:(NSString*)authCode result:(lockResults) lockResult;
@end

NS_ASSUME_NONNULL_END
