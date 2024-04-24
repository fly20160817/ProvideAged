//
//  FLYZiGuangManager.m
//  ProvideAged
//
//  Created by fly on 2021/12/22.
//

#import "FLYZiGuangManager.h"
#import "FLYZiGuangNetwork.h"
#import "UIAlertController+FLYExtension.h"
#import "FLYHash.h"
#import "NSDate+FLYExtension.h"

//创建一个固定的用户，开门、设置wifi等操作都用这个用户操作。
#define k_UserID @"001"

@interface FLYZiGuangManager ()

@end

@implementation FLYZiGuangManager


/// 绑定锁
/// @param lockID 门锁 ID
/// @param communicationType 通信类型
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 成功的回调
+ (void)bindLock:(NSString *)lockID communicationType:(FLYCommunicationType)communicationType otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.查询这把锁是否已绑定
    [FLYZiGuangNetwork getLockBindStatusNetwork:lockID success:^(NSInteger result) {
        
        if ( result == 1 )
        {
            [SVProgressHUD showImage:nil status:@"该门锁已经绑定"];
            return;
        }
        
        //2.连接锁
        [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
            
            //3.读取锁的信息 (获取imei)
            [FLYZiGuang readLockWithLockID:lockID communicationType:communicationType success:^(id result, NSString *NbIMEI) {
                
                //4.从接口获取锁的信息 （超管信息等)
                [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
                    
                    //5.重置锁
                    [FLYZiGuang resetLockWithLockModel:lockModel success:^(id  _Nonnull result) {
                        
                        //6.清除本地密钥
                        [FLYZiGuang cleanUserKeyWithLockID:lockID withUserID:nil];
                        
                        //7.从厂家平台删除锁
                        [FLYZiGuangNetwork deleteLockForManufactorNetwork:lockModel communicationType:communicationType complete:^(NSInteger result) {
                            
                            //8.注册锁
                            [FLYZiGuang registereLockWithLockModel:lockModel communicationType:communicationType success:^(id result, NSString *authKey) {
                                
                                //9.上传厂家平台
                                [FLYZiGuangNetwork uploadLockForManufactorNetwork:lockModel authKey:authKey communicationType:communicationType imei:NbIMEI success:^(id  _Nonnull result) {
                                    
                                    //10.调用我们自己的添加接口
                                    [FLYZiGuangNetwork bindDeviceNetwork:lockID otherParams:otherParams success:^(id  _Nonnull result) {
                                        
                                        !disconnect ?: [self disconnect];
                                        //11.回调
                                        !successBlock ?: successBlock(lockID);
                                        
                                    } failure:^(NSString * reason) {
                                        
                                        !failureBlock ?: failureBlock(reason);
                                        
                                        //11.2重置锁
                                        [FLYZiGuang resetLockWithLockModel:lockModel success:^(id  _Nonnull result) {
                                            
                                            //11.3从厂家平台删除锁
                                            [FLYZiGuangNetwork deleteLockForManufactorNetwork:lockModel communicationType:communicationType complete:^(NSInteger result) {}];
                                            
                                        } failure:^(id  _Nonnull result) {
                                            
                                            //11.3从厂家平台删除锁
                                            [FLYZiGuangNetwork deleteLockForManufactorNetwork:lockModel communicationType:communicationType complete:^(NSInteger result) {}];
                                            
                                        }];
                                    }];
                                    
                                } failure:^(NSString * reason) {
                                    
                                    !failureBlock ?: failureBlock(reason);
                                    
                                    //10.2重置锁
                                    [FLYZiGuang resetLockWithLockModel:lockModel success:^(id  _Nonnull result) {
                                        
                                        !disconnect ?: [self disconnect];
                                        
                                    } failure:^(id  _Nonnull result) {
                                        
                                        !disconnect ?: [self disconnect];
                                    }];
                                }];
                                
                            } failure:^(id  _Nonnull result) {
                                
                                !disconnect ?: [self disconnect];
                                !failureBlock ?: failureBlock(@"注册失败");
                            }];
                        }];
                        
                    } failure:^(id  _Nonnull result) {
                        
                        !disconnect ?: [self disconnect];
                        !failureBlock ?: failureBlock(@"重置锁失败");
                    }];
                    
                } failure:^(NSString * reason) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(reason);
                }];
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"IMEI读取失败");
            }];
            
        } failure:^(id  _Nonnull result) {
            
            [self connectionFailureHandler:[result[@"code"] integerValue]];
            //!failureBlock ?: failureBlock(result);
        }];
        
    } failure:^(NSString * reason) {
        
        !failureBlock ?: failureBlock(reason);
    }];
}


/// 解绑紫光锁
/// @param lockID 紫光锁id
/// @param communicationType 通信类型
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)unboundLock:(NSString *)lockID communicationType:(FLYCommunicationType)communicationType otherParams:(nullable NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
            
            //3.从我们自己的平台删除
            [FLYZiGuangNetwork unboundDeviceNetwork:lockID otherParams:otherParams success:^(id  _Nonnull result) {
                
                //4.重置锁
                [FLYZiGuang resetLockWithLockModel:lockModel success:^(id  _Nonnull result) {
                    
                    //5.清除本地密钥
                    [FLYZiGuang cleanUserKeyWithLockID:lockID withUserID:nil];
                    
                    //6.从厂家平台删除锁
                    [FLYZiGuangNetwork deleteLockForManufactorNetwork:lockModel communicationType:communicationType complete:^(NSInteger result) {
                       
                        !disconnect ?: [self disconnect];
                        //7.回调
                        !successBlock ?: successBlock(lockID);
                        
                    }];
                    
                } failure:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(@"重置锁失败");
                }];
                
            } failure:^(NSString * reason) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(reason);
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}


/// 开锁
/// @param lockID 门锁ID
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)openLock:(NSString *)lockID otherParams:(nullable NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
            
            //3.添加用户
            [FLYZiGuang addUserWithLockModel:lockModel userID:k_UserID success:^(id  _Nonnull result, NSString * _Nonnull authCode) {
                
                //4.执行开锁指令
                [FLYZiGuang openLockWithLockModel:lockModel userID:k_UserID authCode:authCode success:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    
                    //5.添加开锁记录 (告诉我们服务器开锁成功)
                    [FLYZiGuangNetwork addUnlockRecordNetwork:lockID otherParams:/*otherParams*/@{ @"openId" : lockModel.openId } success:^(id  _Nonnull result) {} failure:^(id  _Nonnull result) {}];
                    
                    !successBlock ?: successBlock(lockID);
                    
                } failure:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(@"开锁失败");
                }];
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"添加用户失败");
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}


/// 设置Wifi
/// @param lockID 紫光锁id
/// @param wifiName wifi名称
/// @param wifiPassword wifi密码
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)setupWifi:(NSString *)lockID wifiName:(NSString *)wifiName wifiPassword:(NSString *)wifiPassword otherParams:(nullable NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
            
            //3.添加用户
            [FLYZiGuang addUserWithLockModel:lockModel userID:k_UserID success:^(id  _Nonnull result, NSString * _Nonnull authCode) {
                
                //4.设置Wi-Fi
                [FLYZiGuang setupWifiWithLockModel:lockModel userID:k_UserID authCode:authCode wifiName:wifiName wifiPassword:wifiPassword success:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !successBlock ?: successBlock(lockID);
                    
                } failure:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(@"WiFi设置失败");
                }];
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"添加用户失败");
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}


/// 添加指纹
/// @param lockID 门锁ID
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param progressBlock 当前录入的次数（添加指纹需要多次按压，每次按压都会回调进度）
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addFingerPrint:(NSString *)lockID otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect progress:(void(^)(NSInteger progress))progressBlock success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
            
            NSString * userID = [self getUserID];
            
            //3.添加用户
            [FLYZiGuang addUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result, NSString * _Nonnull authCode) {
                
                //4.添加指纹
                [FLYZiGuang addFingerPrintWithLockModel:lockModel userID:userID authCode:authCode progress:progressBlock success:^(id  _Nonnull result, NSString * _Nonnull fingerprintNo) {
                    
                    //5.告诉我们服务器添加指纹成功
                    [FLYZiGuangNetwork addFingerPrintRecordNetwork:lockModel userID:userID fingerprintNo:fingerprintNo otherParams:otherParams success:^(id  _Nonnull result) {
                        
                        !disconnect ?: [self disconnect];
                        !successBlock ?: successBlock(lockID);
                        
                    } failure:^(NSString * reason) {
                        
                        !disconnect ?: [self disconnect];
                        !failureBlock ?: failureBlock(reason);
                    }];
                    
                } failure:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(@"指纹添加失败");
                }];
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"添加用户失败");
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}

/// 删除指纹
/// @param lockID 门锁ID
/// @param userID 锁内的用户id(删除哪个用户下的指纹) (添加指纹的时候不用传，因为内部自动生成了一个用户id，并且上传了服务器；删除的时候服务器返回给我们，然后拿着这个用户id去删)
/// @param fingerprintNo 指纹编号
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 删除指纹成功之后的回调
/// @param failureBlock 删除指纹失败之后的回调
+ (void)deleteFingerPrint:(NSString *)lockID userID:(NSString *)userID fingerprintNo:(NSInteger)fingerprintNo otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
                        
            //3.添加用户 (其实这个用户已经存在了，再次添加只是为了拿到authCode，重复添加同一个用户，返回的authCode都一样)
            [FLYZiGuang addUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result, NSString * _Nonnull authCode) {
                
                //4.删除指纹
                [FLYZiGuang deleteFingerPrintWithLockModel:lockModel userID:userID authCode:authCode fingerprintNo:fingerprintNo success:^(id  _Nonnull result) {
                    
                    //5.删掉用户
                    [FLYZiGuang deleteUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result) {} failure:^(id  _Nonnull result) {}];
                    
                    //6.清除本地密钥
                    [FLYZiGuang cleanUserKeyWithLockID:lockID withUserID:userID];
                    
                    //7.告诉我们服务器删除指纹成功
                    [FLYZiGuangNetwork deleteFingerPrintRecordNetwork:lockID otherParams:otherParams success:^(id  _Nonnull result) {
                        
                        !disconnect ?: [self disconnect];
                        !successBlock ?: successBlock(lockID);
                        
                    } failure:^(NSString * reason) {
                        
                        !disconnect ?: [self disconnect];
                        !failureBlock ?: failureBlock(reason);
                    }];
                    
                } failure:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(@"指纹删除失败");
                }];
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"添加用户失败");
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}

/// 添加密码
/// @param lockID 门锁ID
/// @param password 需要添加的密码
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addPassword:(NSString *)lockID password:(NSString *)password otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
            
            NSString * userID = [self getUserID];
            
            //3.添加用户
            [FLYZiGuang addUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result, NSString * _Nonnull authCode) {
                
                //4.添加密码
                //同一个用户创建的密码编号不能相同，因为我们每次创建密码都是用不同的用户，所以可以写死。
                NSInteger pwdNo = 100;
                [FLYZiGuang addPasswordWithLockModel:lockModel userID:userID authCode:authCode password:password pwdNo:pwdNo endTime:0 success:^(id  _Nonnull result) {
                    
                    //5.告诉我们服务器添加密码成功
                    [FLYZiGuangNetwork addPasswordRecordNetwork:lockModel userID:userID password:password pwdNo:[@(pwdNo) stringValue] otherParams:otherParams success:^(id  _Nonnull result) {
                        
                        !disconnect ?: [self disconnect];
                        !successBlock ?: successBlock(lockID);
                        
                    } failure:^(NSString * reason) {
                        
                        !disconnect ?: [self disconnect];
                        !failureBlock ?: failureBlock(reason);
                    }];
                    
                } failure:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(@"密码添加失败");
                }];
                
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"添加用户失败");
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}


/// 添加临时密码
/// @param lockID 门锁ID
/// @param endTime 失效时间
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addTempPassword:(NSString *)lockID endTime:(NSInteger)endTime otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
            
            NSString * userID = [self getUserID];
            
            //3.添加用户
            [FLYZiGuang addUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result, NSString * _Nonnull authCode) {
                
                //4.获取服务器生成的密码
                //同一个用户创建的密码编号不能相同，因为我们每次创建密码都是用不同的用户，所以可以写死。
                NSInteger pwdNo = 100;
                [FLYZiGuangNetwork getTempPasswordNetwork:lockModel userID:userID pwdNo:[@(pwdNo) stringValue] endTime:endTime otherParams:otherParams success:^(NSString * _Nonnull password) {
                    
                    //5.添加密码
                    [FLYZiGuang addPasswordWithLockModel:lockModel userID:userID authCode:authCode password:password pwdNo:pwdNo endTime:endTime success:^(id  _Nonnull result) {
                        
                        !disconnect ?: [self disconnect];
                        !successBlock ?: successBlock(lockID);
                        
                    } failure:^(id  _Nonnull result) {
                        
                        !disconnect ?: [self disconnect];
                        !failureBlock ?: failureBlock(@"密码添加失败");
                    }];
                    
                } failure:^(NSString * reason) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(reason);
                }];
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"添加用户失败");
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}

/// 删除密码
/// @param lockID 门锁ID
/// @param userID 锁内的用户id(删除哪个用户下的密码)
/// @param pwdNo 密码序号
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deletePassword:(NSString *)lockID userID:(NSString *)userID pwdNo:(NSInteger)pwdNo otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
                        
            //3.添加用户 (其实这个用户已经存在了，再次添加只是为了拿到authCode，重复添加同一个用户，返回的authCode都一样)
            [FLYZiGuang addUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result, NSString * _Nonnull authCode) {
                
                //4.删除密码
                [FLYZiGuang deletePasswordWithLockModel:lockModel userID:userID authCode:authCode pwdNo:pwdNo success:^(id  _Nonnull result) {
                    
                    //5.删掉用户
                    [FLYZiGuang deleteUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result) {} failure:^(id  _Nonnull result) {}];
                    
                    //6.清除本地密钥
                    [FLYZiGuang cleanUserKeyWithLockID:lockID withUserID:userID];
                    
                    //7.告诉我们服务器删除密码成功
                    [FLYZiGuangNetwork deletePasswordRecordNetwork:lockID otherParams:otherParams success:^(NSString * _Nonnull password) {
                        
                        !disconnect ?: [self disconnect];
                        !successBlock ?: successBlock(lockID);
                        
                    } failure:^(NSString * reason) {
                        
                        !disconnect ?: [self disconnect];
                        !failureBlock ?: failureBlock(reason);
                    }];
                    
                } failure:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(@"密码删除失败");
                }];
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"添加用户失败");
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}


/// 添加门卡
/// @param lockID 门锁ID
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addCard:(NSString *)lockID otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
            
            NSString * userID = [self getUserID];
            
            //3.添加用户
            [FLYZiGuang addUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result, NSString * _Nonnull authCode) {
                
                //4.添加门卡
                //同一个用户创建的密码编号不能相同，因为我们每次创建密码都是用不同的用户，所以可以写死。
                NSInteger cardIndex = 100;
                [FLYZiGuang addCardWithLockModel:lockModel userID:userID authCode:authCode cardIndex:cardIndex endTime:0 success:^(id  _Nonnull result, NSString * _Nonnull cardNo) {
                    
                    //打入安全卡用的？暂时没用到
                    //NSLog(@"cardNo = %@", cardNo);
                    
                    //5.告诉我们服务器添加门卡成功
                    [FLYZiGuangNetwork addCardRecordNetwork:lockModel userID:userID cardIndex:[@(cardIndex) stringValue] otherParams:otherParams success:^(id  _Nonnull result) {
                        
                        !disconnect ?: [self disconnect];
                        !successBlock ?: successBlock(lockID);
                        
                    } failure:^(NSString * reason) {
                        
                        !disconnect ?: [self disconnect];
                        !failureBlock ?: failureBlock(reason);
                    }];
                    
                } failure:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(@"门卡添加失败");
                }];
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"添加用户失败");
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}


/// 添加临时门卡
/// @param lockID 门锁ID
/// @param endTime 失效时间 (秒级时间戳)
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)addTempCard:(NSString *)lockID endTime:(NSInteger)endTime otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
            
            NSString * userID = [self getUserID];
            
            //3.添加用户
            [FLYZiGuang addUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result, NSString * _Nonnull authCode) {
                
                //4.添加门卡
                //同一个用户创建的密码编号不能相同，因为我们每次创建密码都是用不同的用户，所以可以写死。
                NSInteger cardIndex = 100;
                [FLYZiGuang addCardWithLockModel:lockModel userID:userID authCode:authCode cardIndex:cardIndex endTime:endTime success:^(id  _Nonnull result, NSString * _Nonnull cardNo) {
                    
                    //打入安全卡用的？暂时没用到
                    //NSLog(@"cardNo = %@", cardNo);
                    
                    //5.告诉我们服务器添加临时门卡成功
                    [FLYZiGuangNetwork addTempCardRecordNetwork:lockModel userID:userID cardIndex:[@(cardIndex) stringValue] endTime:endTime otherParams:otherParams success:^(id  _Nonnull result) {
                        
                        !disconnect ?: [self disconnect];
                        !successBlock ?: successBlock(lockID);
                        
                    } failure:^(NSString * reason) {
                        
                        !disconnect ?: [self disconnect];
                        !failureBlock ?: failureBlock(reason);
                        
                    }];
                    
                } failure:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(@"门卡添加失败");
                }];
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"添加用户失败");
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}


/// 删除门卡
/// @param lockID 门锁ID
/// @param userID 锁内的用户id(删除哪个用户下的门卡)
/// @param cardIndex 密码序号
/// @param otherParams 上传我们自己平台需要用的的参数
/// @param disconnect 执行完成之后，是否断开蓝牙连接
/// @param successBlock 成功的回调
/// @param failureBlock 失败的回调
+ (void)deleteCard:(NSString *)lockID userID:(NSString *)userID cardIndex:(NSInteger)cardIndex otherParams:(NSDictionary *)otherParams disconnect:(BOOL)disconnect success:(void(^)(NSString * lockId))successBlock failure:(void(^)(NSString * reason))failureBlock
{
    //1.连接锁
    [FLYZiGuang connectionLockWithLockID:lockID success:^(id result) {
        
        //2.从接口获取锁的信息 （超管信息等)
        [FLYZiGuangNetwork getLockInfoNetwork:lockID otherParams:otherParams success:^(FLYZiGuangModel * _Nonnull lockModel) {
                        
            //3.添加用户 (其实这个用户已经存在了，再次添加只是为了拿到authCode，重复添加同一个用户，返回的authCode都一样)
            [FLYZiGuang addUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result, NSString * _Nonnull authCode) {
                
                //4.删除门卡
                [FLYZiGuang deleteCardWithLockModel:lockModel userID:userID authCode:authCode cardIndex:cardIndex success:^(id  _Nonnull result) {
                    
                    //5.删掉用户
                    [FLYZiGuang deleteUserWithLockModel:lockModel userID:userID success:^(id  _Nonnull result) {} failure:^(id  _Nonnull result) {}];
                    
                    //6.清除本地密钥
                    [FLYZiGuang cleanUserKeyWithLockID:lockID withUserID:userID];
                    
                    //7.告诉我们服务器删除门卡成功
                    [FLYZiGuangNetwork deleteCardRecordNetwork:lockID otherParams:otherParams success:^(id  _Nonnull result) {
                        
                        !disconnect ?: [self disconnect];
                        !successBlock ?: successBlock(lockID);
                        
                    } failure:^(NSString * reason) {
                        
                        !disconnect ?: [self disconnect];
                        !failureBlock ?: failureBlock(reason);
                    }];
                    
                } failure:^(id  _Nonnull result) {
                    
                    !disconnect ?: [self disconnect];
                    !failureBlock ?: failureBlock(@"门卡删除失败");
                }];
                
            } failure:^(id  _Nonnull result) {
                
                !disconnect ?: [self disconnect];
                !failureBlock ?: failureBlock(@"添加用户失败");
            }];
            
        } failure:^(NSString * reason) {
            
            !disconnect ?: [self disconnect];
            !failureBlock ?: failureBlock(reason);
        }];
        
    } failure:^(id  _Nonnull result) {
        
        [self connectionFailureHandler:[result[@"code"] integerValue]];
        //!failureBlock ?: failureBlock(result);
    }];
}


/// 断开连接
+ (void)disconnect
{
    [FLYZiGuang disconnect];
}



#pragma mark - private methods

/// 蓝牙连接失败的处理
+ (void)connectionFailureHandler:(NSInteger)code
{
    if ( code == 65 )
    {
        [SVProgressHUD showInfoWithStatus:@"未找到蓝牙设备\n请靠近门锁重试"];
    }
    else if ( code == 66 )
    {
        [SVProgressHUD showImage:nil status:@"手机蓝牙未打开"];
    }
    else if ( code == 1001 || code == 1002 || code == 1003 || code == 1004 )
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请您开启蓝牙权限" message:nil preferredStyle:(UIAlertControllerStyleAlert) titles:@[@"取消", @"去开启"] alertAction:^(NSInteger index) {
            
            if ( index == 1 )
            {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
        }];
        [alertController show];
    }
    else
    {
        //[SVProgressHUD showErrorWithStatus:@"蓝牙连接失败"];
    }
}

//根据时间戳，生成一个userID
+ (NSString *)getUserID
{
    //获取当前的时间戳
    NSString * userID = [NSDate currentTimeStamp];
    
    //时间戳再拼上一个随机数 (确保同一时间生成的userID不会重复)
    userID = [NSString stringWithFormat:@"%@%d", userID, arc4random_uniform(100)];
    
    //md5加密
    userID = [FLYHash MD5:userID];
     
    //取后16位
    userID = [userID substringWithRange:NSMakeRange(8, 16)];
    
    return userID;
}

@end
