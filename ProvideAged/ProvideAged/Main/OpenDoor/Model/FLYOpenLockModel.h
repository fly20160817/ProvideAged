//
//  FLYOpenLockModel.h
//  ProvideAged
//
//  Created by fly on 2022/1/4.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYOpenLockModel : FLYModel

@property (nonatomic, assign) CGFloat electricity;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * imei;
//是否显示忘记密码（1=是、2=否）
@property (nonatomic, assign) NSInteger isShowForgotPassword;
@property (nonatomic, strong) NSString * lockSignal;
@property (nonatomic, strong) NSString * model;
@property (nonatomic, strong) NSString * name;
//门锁类型 4=紫光
@property (nonatomic, assign) NSInteger bluetoothType;
//是否支持人脸功能：1=是、2=否
@property (nonatomic, assign) NSInteger supportFace;

@end

NS_ASSUME_NONNULL_END
