//
//  FLYZiGuangNetwork.m
//  ProvideAged
//
//  Created by fly on 2021/12/22.
//

#import "FLYZiGuangNetwork.h"
#import "FLYHash.h"
#import "NSDate+FLYExtension.h"

//生产环境的客户编码
#define k_CustomerCode_P @"4641602e0d204bcb9de40763bb08c0ee"
//测试环境的客户编码
#define k_CustomerCode_T @"d17e10edc99342d89794395ff0e60cbb"

@implementation FLYZiGuangNetwork


#pragma mark - 自己平台的接口

/// 查询锁是否已经绑定
/// @param lockID 锁的id
/// @param successBlock 查询结果 (0未绑定 1已绑定)
/// @param failureBlock 查询失败
+ (void)getLockBindStatusNetwork:(NSString *)lockID success:(void(^)(NSInteger result))successBlock failure:(nullable void(^)(NSString * reason))failureBlock
{
    !successBlock ?: successBlock(0);
    return;
    
    
    NSDictionary * params = @{ @"imei" : lockID };
    
    [FLYNetworkTool postWithPath:@"lockInfo/findSingleByImei" params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(0);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];
    }];
    
}


/// 获取锁的信息 （超管信息等)
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 回调锁的数据模型
/// @param failureBlock 失败的回调
+ (void)getLockInfoNetwork:(NSString *)lockID otherParams:(NSDictionary *)otherParams success:(void(^)(FLYZiGuangModel * lockModel))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"id" : otherParams[@"deviceInfoId"] };
    
    NSString * path = @"lockInfo/selectPurpleLightConfig";
    
    [FLYNetworkTool postRawWithPath:path params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {
        
//        if ( [json[@"code"] integerValue] != 0 )
//        {
//            [SVProgressHUD showErrorWithStatus:json[@"message"]];
//            return;
//        }
        
        //新锁查不到就完全自己创建信息
        FLYZiGuangModel * lockModel = [[FLYZiGuangModel alloc] init];
        if ( [json[@"code"] integerValue] == 200 )
        {
            lockModel = [FLYZiGuangModel mj_objectWithKeyValues:json[@"content"]];
        }
        else
        {
            lockModel.deviceId = lockID;
            lockModel.authKey = @"";
            lockModel.imei = lockID;
        }
                             
        //如果没有超管id，自己生成
        if ( lockModel.lockerSuperAdminId.length == 0 )
        {
            //lockID + hans (加盐)
            NSString * lockerSuperAdminId = [NSString stringWithFormat:@"%@hans", lockID];
            //md5加密
            lockerSuperAdminId = [FLYHash MD5:lockerSuperAdminId];
            //只取前6位
            lockerSuperAdminId = [lockerSuperAdminId substringWithRange:NSMakeRange(0, 6)];
                            
            lockModel.lockerSuperAdminId = lockerSuperAdminId;
            lockModel.authKey = @"";
        }
        
        !successBlock ?: successBlock(lockModel);
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"失败：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];
    }];
    
}


/// 绑定门锁
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)bindDeviceNetwork:(NSString *)lockID otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    
    NSDictionary * params = @{ @"imei" : lockID, @"name" : otherParams[@"name"], @"equipmentTypeId" : otherParams[@"equipmentTypeId"] };
        
    [FLYNetworkTool postRawWithPath:@"lockInfo/addLock" params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {
        
        NSLog(@"自己平台绑定：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"自己平台绑定：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];
        
    }];
}

/// 解绑门锁
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)unboundDeviceNetwork:(NSString *)lockID otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"imei" : lockID };
    
    [FLYNetworkTool getWithPath:@"bluetooth/init" params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {
        
        NSLog(@"自己平台解绑：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"自己平台解绑：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];
 
    }];
}


/// 添加开锁记录 (告诉我们的服务器开锁成功)
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addUnlockRecordNetwork:(NSString *)lockID otherParams:(nullable NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"openId" : otherParams[@"openId"] };
    NSString * path = @"lockInfo/purpleLightBluetoothResult";
    
    [FLYNetworkTool postRawWithPath:path params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {
        
        NSLog(@"添加开锁记录：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"添加开锁记录：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];
        
    }];
}


/// 添加指纹 (告诉我们的服务器添加指纹成功)
/// @param lockModel 锁的数据模型
/// @param userID 锁内的用户id
/// @param fingerprintNo 指纹编号
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addFingerPrintRecordNetwork:(FLYZiGuangModel *)lockModel userID:(NSString *)userID fingerprintNo:(NSString *)fingerprintNo otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"deviceInfoId" : otherParams[@"deviceInfoId"], @"openTypeList" : @[@(2)], @"purpose" : @"家属授权", @"name" : [FLYUser sharedUser].userName, @"phone" : [FLYUser sharedUser].phone, @"startTime" : @"1970-01-01 00:00:00", @"endTime" : @"2099-01-01 00:00:00", @"bluetooth" : @"1", @"lockUserId" : userID, @"lockPawId" : fingerprintNo, @"remark" : otherParams[@"remark"]  };
    
    NSString * path = API_ADDTEMPAUTH;

    [FLYNetworkTool postRawWithPath:path params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {

        NSLog(@"已记录添加指纹：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }

    } failure:^(NSError * _Nonnull error) {

        NSLog(@"记录添加指纹失败：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];
    }];
}


/// 告诉我们的服务器删除指纹成功
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteFingerPrintRecordNetwork:(NSString *)lockID otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"batchId" : otherParams[@"batchId"], @"deviceInfoId" : otherParams[@"deviceInfoId"] };
    NSString * path = API_DELETEAUTH;

    [FLYNetworkTool postRawWithPath:path params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {

        NSLog(@"已记录删除指纹：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }

    } failure:^(NSError * _Nonnull error) {

        NSLog(@"记录删除指纹失败：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];

    }];
}


/// 告诉我们的服务器添加密码成功
/// @param lockModel 锁的数据模型
/// @param userID 锁内的用户id
/// @param password 密码
/// @param pwdNo 密码序号
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addPasswordRecordNetwork:(FLYZiGuangModel *)lockModel userID:(NSString *)userID password:(NSString *)password pwdNo:(NSString *)pwdNo otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"imei" : lockModel.imei, @"keyId" : lockModel.keyID, @"lockerUserId" : userID, @"password" : password, @"passwordIndex" : pwdNo, @"userType" : @"1", @"name" : otherParams[@"name"], @"type" : @"1", @"userInfoId" : otherParams[@"userInfoId"], @"phone" : otherParams[@"phone"] };
    NSString * path = @"bluetooth/addLockUserPassword";

    [FLYNetworkTool postRawWithPath:path params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {

        NSLog(@"已记录添加密码：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }

    } failure:^(NSError * _Nonnull error) {

        NSLog(@"已记录添加密码：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];

    }];
}

/// 获取服务器生成的密码 (临时密码用)
/// @param lockModel 锁的数据模型
/// @param userID 锁内的用户id
/// @param pwdNo 密码序号
/// @param endTime 失效时间
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)getTempPasswordNetwork:(FLYZiGuangModel *)lockModel userID:(NSString *)userID pwdNo:(NSString *)pwdNo endTime:(NSInteger)endTime otherParams:(NSDictionary *)otherParams success:(void(^)(NSString * password))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"imei" : lockModel.imei, @"keyId" : lockModel.keyID, @"lockerUserId" : userID, @"passwordIndex" : pwdNo, @"userType" : @"1", @"name" : otherParams[@"name"], @"type" : @"1", @"userInfoId" : otherParams[@"userInfoId"], @"phone" : otherParams[@"phone"], @"endTime" : [@(endTime) stringValue], @"startTime" : [NSDate currentTimeStamp], @"lockInfoId" : otherParams[@"lockInfoId"] };
    NSString * path = @"bluetooth/temporaryPassword";

    [FLYNetworkTool postRawWithPath:path params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {

        NSLog(@"生成临时密码：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            NSString * password = json[@"content"][@"password"];
            !successBlock ?: successBlock(password);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }

    } failure:^(NSError * _Nonnull error) {

        NSLog(@"生成临时密码失败：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];

    }];
}

/// 告诉我们的服务器删除密码成功
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deletePasswordRecordNetwork:(NSString *)lockID otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"imei" : lockID, @"passwordId" : otherParams[@"passwordId"] };
    NSString * path = @"bluetooth/delLockUserPassword";

    [FLYNetworkTool postRawWithPath:path params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {

        NSLog(@"已记录删除密码：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }

    } failure:^(NSError * _Nonnull error) {

        NSLog(@"记录删密码纹：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];

    }];
}


/// 告诉我们的服务器添加门卡成功
/// @param lockModel 锁的数据模型
/// @param userID 锁内的用户id
/// @param cardIndex 门卡序号
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addCardRecordNetwork:(FLYZiGuangModel *)lockModel userID:(NSString *)userID cardIndex:(NSString *)cardIndex otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"imei" : lockModel.imei, @"keyId" : lockModel.keyID, @"lockerUserId" : userID, @"cardIndex" : cardIndex, @"userType" : @"1", @"name" : otherParams[@"name"], @"type" : @"3", @"userInfoId" : otherParams[@"userInfoId"], @"phone" : otherParams[@"phone"] };
    NSString * path = @"bluetooth/addLockUserPassword";

    [FLYNetworkTool postRawWithPath:path params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {

        NSLog(@"记录添加门卡：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }

    } failure:^(NSError * _Nonnull error) {

        NSLog(@"记录添加门卡：%@", error);

        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];
    }];
}

/// 告诉我们的服务器添加临时门卡成功
/// @param lockModel 锁的数据模型
/// @param userID 锁内的用户id
/// @param cardIndex 门卡序号
/// @param endTime 失效时间
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addTempCardRecordNetwork:(FLYZiGuangModel *)lockModel userID:(NSString *)userID cardIndex:(NSString *)cardIndex endTime:(NSInteger)endTime otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"imei" : lockModel.imei, @"keyId" : lockModel.keyID, @"lockerUserId" : userID, @"password" : otherParams[@"cardNum"], @"cardIndex" : cardIndex, @"userType" : @"1", @"name" : otherParams[@"name"], @"type" : @"1", @"userInfoId" : otherParams[@"userInfoId"], @"phone" : otherParams[@"phone"], @"endTime" : [@(endTime) stringValue], @"startTime" : [NSDate currentTimeStamp], @"lockInfoId" : otherParams[@"lockInfoId"] };
    NSString * path = @"bluetooth/temporaryPassword";

    [FLYNetworkTool postRawWithPath:path params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {

        NSLog(@"记录添加临时门卡：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }

    } failure:^(NSError * _Nonnull error) {

        NSLog(@"记录添加临时门卡：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];

    }];
}


/// 告诉我们的服务器删除门卡成功
/// @param lockID 锁的id
/// @param otherParams 自己平台需要用到的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteCardRecordNetwork:(NSString *)lockID otherParams:(NSDictionary *)otherParams success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSDictionary * params = @{ @"imei" : lockID, @"passwordId" : otherParams[@"passwordId"] };
    NSString * path = @"bluetooth/delLockUserPassword";

    [FLYNetworkTool postRawWithPath:path params:params loadingType:(FLYNetworkLoadingTypeNone) loadingTitle:nil isHandle:NO success:^(id  _Nonnull json) {

        NSLog(@"记录删除门卡：%@", json);
        
        if ( [json[@"code"] integerValue] == 200 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(json[@"message"]);
        }
    
    } failure:^(NSError * _Nonnull error) {

        NSLog(@"记录删门卡纹：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];
    }];
}



#pragma mark - 厂家平台的接口

/// 上传锁信息到厂家平台
/// @param lockModel lockModel
/// @param authKey 鉴权密钥 (在第一次注册绑定门锁时，会从锁端拿到)
/// @param communicationType 通信类型
/// @param imei imei
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)uploadLockForManufactorNetwork:(FLYZiGuangModel *)lockModel authKey:(NSString *)authKey communicationType:(FLYCommunicationType)communicationType imei:(NSString *)imei success:(void(^)(id result))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    NSString * url = @"https://icintech.gosinoic.com/nbdev/customer/registerLocker";
    
    //判断url，使用不同的客户编码
    //客户编码（生产环境）
    NSString * customerCode = k_CustomerCode_P;
//    if( [BASE_API isEqualToString:@"https://pilock.hanspro.cn"] )
//    {
//        //客户编码（测试环境）
//        customerCode = k_CustomerCode_T;
//    }
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:lockModel.deviceId forKey:@"lockerId"];
    [params setObject:lockModel.lockerSuperAdminId forKey:@"lockerSuperAdminId"];
    [params setObject:customerCode forKey:@"customerCode"];
    [params setObject:@(communicationType) forKey:@"type"];
    [params setObject:authKey forKey:@"authKey"];
    if ( communicationType == 1)
    {
        [params setObject:imei forKey:@"imei"];
    }
    
    
    [FLYNetwork postWithPath:url params:params success:^(id  _Nonnull json) {
        
        
        NSLog(@"上传厂家平台：%@", json);
        
        if ( [json[@"code"] integerValue] == 0 )
        {
            !successBlock ?: successBlock(json);
        }
        else
        {
            !failureBlock ?: failureBlock(@"上传厂家平台失败");
        }
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"上传厂家平台：%@", error);
        
        [FLYNetwork getNetType:^(BOOL network) {
            
            NSString * reason = network ? @"服务器异常，请稍后重试。" : @"您的网络好像出现了问题";
            !failureBlock ?: failureBlock(reason);
        }];
        
    }];
    
}


/// 从厂家平台删除锁
/// @param lockModel 锁的id
/// @param communicationType 通信类型
/// @param completeBlock 结果 (0删除失败 1删除成功)
+ (void)deleteLockForManufactorNetwork:(FLYZiGuangModel *)lockModel communicationType:(FLYCommunicationType)communicationType complete:(void(^)(NSInteger result))completeBlock
{
    NSString * url = @"https://icintech.gosinoic.com/nbdev/customer/unregisterLocker";
    
    //判断url，使用不同的客户编码
    //客户编码（生产环境）
    NSString * customerCode = k_CustomerCode_P;
//    if( [BASE_API isEqualToString:@"https://pilock.hanspro.cn"] )
//    {
//        //客户编码（测试环境）
//        customerCode = k_CustomerCode_T;
//    }
    
    
    NSDictionary * params = @{ @"lockerId" : lockModel.deviceId, @"type" : @(communicationType), @"customerCode" : customerCode };
    
    [FLYNetwork postWithPath:url params:params success:^(id  _Nonnull json) {
        
        NSLog(@"从厂家平台删除：%@", json);
        
        !completeBlock ?: completeBlock(1);
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"从厂家平台删除：%@", error);
        
        !completeBlock ?: completeBlock(0);
    }];
}


@end


