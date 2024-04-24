//
//  FLYZiGuang.m
//  ProvideAged
//
//  Created by fly on 2021/12/22.
//

#import "FLYZiGuang.h"
#import <ICINSmartLockSDK/ICINSmartLockManage.h>
#import "NSDate+FLYExtension.h"

//直连的ip
#define k_Direct_Ip @"103.120.227.76"
//直连的端口
#define k_Direct_Port @"9090"

//AEP的ip
#define k_AEP_Ip @"221.229.214.202"
//AEP的端口
#define k_AEP_Port @"5683"


@implementation FLYZiGuang

/// 连接锁
/// @param lockID 锁的id (格式：ICIN_59789c5d32d9)
/// @param successBlock 连接成功的回调
/// @param failureBlock 连接失败的回调
+ (void)connectionLockWithLockID:(NSString *)lockID success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock
{
    [ICINSmartLockManage icin_connectionLockID:lockID Result:^(id  _Nonnull result) {
        
        NSLog(@"连接锁：%@", result);
        
        if ( [result[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(result);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
        
    }];
}


/// 读取锁的信息
/// @param lockID 锁的id
/// @param communicationType 通信类型
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)readLockWithLockID:(NSString *)lockID communicationType:(FLYCommunicationType)communicationType success:(void(^)(id result, NSString * NbIMEI))successBlock failure:(void(^)(id result))failureBlock
{
    //不是AEP类型的不用读取IMEI
    if ( communicationType == FLYCommunicationTypeDirect )
    {
        !successBlock ?: successBlock(nil, nil);
        return;
    }
    
    [ICINSmartLockManage icin_getLockMessageLockID:lockID result:^(id  _Nonnull result) {
        
        NSLog(@"读取锁的信息：%@", result);
        
        if ( [result[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(result, result[@"NbIMEI"]);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
    }];
}


/// 重置锁
/// @param lockModel 锁的数据模型（超管之类的信息）
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)resetLockWithLockModel:(FLYZiGuangModel *)lockModel success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock
{
    [ICINSmartLockManage icin_resetLockID:lockModel.deviceId SuperAdminId:lockModel.lockerSuperAdminId KeyID:lockModel.keyID AuthKey:lockModel.authKey result:^(id  _Nonnull result) {
        
        NSLog(@"重置锁：%@", result);
        
        if ( [result[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(result);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
        
    }];
}


/// 注册锁
/// @param lockModel 锁的数据模型
/// @param communicationType 通信类型
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)registereLockWithLockModel:(FLYZiGuangModel *)lockModel communicationType:(FLYCommunicationType)communicationType success:(void(^)(id result, NSString *authKey))successBlock failure:(void(^)(id result))failureBlock
{
    NSString * ip = k_Direct_Ip;
    NSString * port = k_Direct_Port;
    
    if( communicationType == FLYCommunicationTypeAEP )
    {
        ip = k_AEP_Ip;
        port = k_AEP_Port;
    }
    
    [ICINSmartLockManage icin_registereSuperAdminLockID:lockModel.deviceId SuperAdminKeyID:lockModel.keyID SuperAdminID:lockModel.lockerSuperAdminId Time:[[NSDate currentTimeStamp] integerValue] NBIP:ip NBPort:port result:^(id  _Nonnull result) {
        
        NSLog(@"注册锁：%@", result);
        
        if ( [result[@"code"] integerValue] == 0 )
        {
            NSString * authKey = result[@"authKey"];
            //有可能接口返回的authKey不正确，导致重置锁失败，然后继续走注册锁，因为超管id都是有规则的，所以这次生成的和以前的是一样的，也能注册成功，这里拿到最新的authKey，替换model里的authKey，然后继续往下走
            lockModel.authKey = authKey;
            
            !successBlock ?: successBlock(result, authKey);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
        
    }];
}


/// 添加用户
/// @param lockModel 锁的数据模型
/// @param userID 要添加的用户ID
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addUserWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID success:(void(^)(id result, NSString *authCode))successBlock failure:(void(^)(id result))failureBlock
{
   
    [ICINSmartLockManage icin_registereUserLockID:lockModel.imei SuperAdminId:lockModel.lockerSuperAdminId UserID:userID UserKeyID:lockModel.keyID Role:0 AuthKey:lockModel.authKey result:^(id  _Nonnull result) {

        NSLog(@"添加用户：%@", result);

        if ( [result[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(result, result[@"authCode"]);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
        
    }];
}


/// 删除用户
/// @param lockModel 锁的数据模型
/// @param userID 要删除的用户ID
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteUserWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock
{
    [ICINSmartLockManage icin_deleteUserLockID:lockModel.imei SuperAdmindID:lockModel.lockerSuperAdminId UserKeyID:lockModel.keyID DelUserID:userID AuthKey:lockModel.authKey result:^(id  _Nonnull result) {
        
        NSLog(@"删除用户：%@", result);
        
        if ( [result[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(result);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
        
    }];
}


/// 清除本地密钥 (删除用户、重置、鉴权错误 9 时需要清除本地密钥)
/// @param lockID 锁的id
/// @param userID 用户ID
+ (void)cleanUserKeyWithLockID:(NSString*)lockID withUserID:(NSString*)userID
{
    [ICINSmartLockManage icin_cleanUserKeyLockID:lockID withUserID:userID];
}


/// 开锁
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码 (添加用户时返回该鉴权码，除超管外，每个用户都对应一个鉴权码)
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)openLockWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock
{
    [ICINSmartLockManage icin_openLockLockID:lockModel.imei SuperAdminId:lockModel.lockerSuperAdminId UserID:userID KeyID:lockModel.keyID OpenTime:[[NSDate currentTimeStamp] integerValue] OpenModel:0 AuthCode:authCode result:^(id  _Nonnull result) {
        
        NSLog(@"开锁：%@", result);
        
        if ( [result[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(result);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
        
    }];
}


/// 设置WiFi
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param wifiName wifi名字
/// @param wifiPassword wifi密码
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)setupWifiWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode wifiName:(NSString *)wifiName wifiPassword:(NSString *)wifiPassword success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock
{
    [ICINSmartLockManage icin_setWIFILockID:lockModel.imei SuperAdminId:lockModel.lockerSuperAdminId UserID:userID KeyID:lockModel.keyID WIFISSID:wifiName WiFiPwd:wifiPassword AuthCode:authCode result:^(id  _Nonnull result) {
                
        NSLog(@"设置Wi-Fi：%@", result);
        
        if ( [result[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(result);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
        
    }];
}


/// 添加指纹
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param progressBlock 当前录入的次数（添加指纹需要多次按压，每次按压都会回调进度）
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addFingerPrintWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode progress:(void(^)(NSInteger progress))progressBlock success:(void(^)(id result, NSString *fingerprintNo))successBlock failure:(void(^)(id result))failureBlock
{
    [ICINSmartLockManage icin_addFingerPrintLockID:lockModel.imei SuperAdminId:lockModel.lockerSuperAdminId AuthUserID:userID AuthUserKeyID:lockModel.keyID UserID:userID IsAlarm:0 AuthCode:authCode result:^(id  _Nonnull result) {
        
        NSLog(@"添加指纹：%@", result);
        
        if ( [result[@"code"] integerValue] == 0 )
        {
            !progressBlock ?: progressBlock([result[@"curRecord"] integerValue]);
            
            //completeflag录制完成标志  0:未完成，1:完成
            if ( [result[@"completeflag"] integerValue] == 1 )
            {
                !successBlock ?: successBlock(result, result[@"fingerprintNo"]);
            }
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
    }];
}


/// 删除指纹
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param fingerprintNo 指纹编号
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteFingerPrintWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode fingerprintNo:(NSInteger)fingerprintNo success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock
{
    [ICINSmartLockManage icin_deleteFingerPrintLockID:lockModel.imei SuperAdminId:lockModel.lockerSuperAdminId AuthUserID:userID AuthuserKeyID:lockModel.keyID UserID:userID FingerprintNo:fingerprintNo AuthCode:authCode result:^(id  _Nonnull result) {
        
        NSLog(@"删除指纹：%@", result);
        
        if ( [result[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(result);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
        
    }];
}


/// 添加密码
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param password 需要添加的密码
/// @param pwdNo 密码序号 (自己生成，同一个用户下的pwdNo必须唯一)
/// @param endTime 失效时间 (永久密码endTime就传0，时效密码就传结束时的秒级时间戳)
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addPasswordWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode password:(NSString *)password pwdNo:(NSInteger)pwdNo endTime:(NSInteger)endTime success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock
{
    //永久密码的EndTime本来应该传0，但传0会闪退，所以传了个10年后的时间戳，不会十年后还有人在用这个app吧😂
    if (endTime == 0 )
    {
        endTime = 1955170835;
    }
    
    [ICINSmartLockManage icin_managePassWordLockID:lockModel.imei SuperAdminId:lockModel.lockerSuperAdminId AuthUserID:userID AuthUserkeyID:lockModel.keyID UserID:userID PwdNo:pwdNo UseCountLimit:255 Pwd:password StartTime:0 EndTime:endTime AuthCode:authCode result:^(id  _Nonnull result) {

        NSLog(@"添加密码：%@", result);

        if ( [result[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(result);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }

    }];
}


/// 删除密码
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param pwdNo 密码序号
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deletePasswordWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode pwdNo:(NSInteger)pwdNo success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock
{
    [ICINSmartLockManage icin_managePassWordLockID:lockModel.imei SuperAdminId:lockModel.lockerSuperAdminId AuthUserID:userID AuthUserkeyID:lockModel.keyID UserID:userID PwdNo:pwdNo UseCountLimit:0 Pwd:@"" StartTime:0x00 EndTime:0xff AuthCode:authCode result:^(id  _Nonnull result) {

        NSLog(@"删除密码：%@", result);

        if ( [result[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(result);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }

    }];
}


/// 添加门卡
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param cardIndex 门卡序号(自己生成，同一个用户下的cardIndex必须唯一)
/// @param endTime 失效时间 (永久门卡endTime就传0，时效门卡就传结束时的秒级时间戳)
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addCardWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode cardIndex:(NSInteger)cardIndex endTime:(NSInteger)endTime success:(void(^)(id result, NSString *cardNo))successBlock failure:(void(^)(id result))failureBlock
{
    [ICINSmartLockManage icin_addCardLockID:lockModel.imei SuperAdminId:lockModel.lockerSuperAdminId AuthUserID:userID AuthUserKeyID:lockModel.keyID UserID:userID CardIndex:cardIndex AuthCode:authCode result:^(id  _Nonnull result) {
        
        NSLog(@"添加门卡：%@", result);

        if ( [result[@"code"] integerValue] == 0 )
        {
            //completeFlag录制完成标志 0:未完成，1:完成
            if ( [result[@"completeFlag"] integerValue] == 1 )
            {
                !successBlock ?: successBlock(result, result[@"cardNo"]);
            }
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }

    }];
}


/// 删除门卡
/// @param lockModel 锁的数据模型
/// @param userID 用户id
/// @param authCode 用户的鉴权码
/// @param cardIndex 门卡序号
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteCardWithLockModel:(FLYZiGuangModel *)lockModel userID:(NSString *)userID authCode:(NSString *)authCode cardIndex:(NSInteger)cardIndex success:(void(^)(id result))successBlock failure:(void(^)(id result))failureBlock
{
    [ICINSmartLockManage icin_deleteCardLockID:lockModel.imei SuperAdminId:lockModel.lockerSuperAdminId AuthUserID:userID AuthuserKeyID:lockModel.keyID UserID:userID CardIndex:cardIndex AuthCode:authCode result:^(id  _Nonnull result) {
        
        NSLog(@"删除门卡结果：%@", result);

        //等于10是密码已经失效了，也当删除成功处理
        if ( [result[@"code"] integerValue] == 0 || [result[@"code"] integerValue] == 10 )
        {
            !successBlock ?: successBlock(result);
        }
        else
        {
            !failureBlock ?: failureBlock(result);
        }
        
    }];
}


/// 断开连接
+ (void)disconnect
{
    [ICINSmartLockManage icin_disconnect];
}


@end
