//
//  FLYZiGuangModel.h
//  ProvideAged
//
//  Created by fly on 2021/12/22.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYZiGuangModel : FLYModel

@property (nonatomic, strong) NSString * applicationProductsId;
@property (nonatomic, strong) NSString * authKey;
@property (nonatomic, strong) NSString * ccid;
@property (nonatomic, strong) NSString * openId;
@property (nonatomic, strong) NSString * deviceId;
@property (nonatomic, strong) NSString * electricity;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * imei;
@property (nonatomic, strong) NSString * imsi;
@property (nonatomic, strong) NSString * lastTelletTime;
@property (nonatomic, strong) NSString * lockSignal;
@property (nonatomic, strong) NSString * lockerSuperAdminId;
@property (nonatomic, assign) NSInteger onlineStatus;
@property (nonatomic, strong) NSString * sw;
@property (nonatomic, strong) NSString * keyId;


//自己添加的属性 （两个lockerSuperAdminId拼在一起，在.m文件里get方法里实现）
@property (nonatomic, strong) NSString * keyID;

@end

NS_ASSUME_NONNULL_END
