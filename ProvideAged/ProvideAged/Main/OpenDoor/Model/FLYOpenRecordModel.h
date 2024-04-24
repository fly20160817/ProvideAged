//
//  FLYOpenRecordModel.h
//  ProvideAged
//
//  Created by fly on 2022/1/4.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYOpenRecordModel : FLYModel

@property (nonatomic, strong) NSString * authEndTime;
@property (nonatomic, strong) NSString * authStartTime;
@property (nonatomic, strong) NSString * deviceInfoId;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * imei;
@property (nonatomic, strong) NSString * lockAuthorizeId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * openTime;
//开门方式(1=密码、2=指纹、3=门卡、4=蓝牙)
@property (nonatomic, assign) NSInteger openType;
@property (nonatomic, strong) NSString * openTypeDesc;
@property (nonatomic, strong) NSString * phone;
//授权类型(1=老人、2=家属、3=临时授权)
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * typeDesc;

@end

NS_ASSUME_NONNULL_END
