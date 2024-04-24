//
//  FLYHouseLockModel.h
//  ProvideAged
//
//  Created by fly on 2021/12/30.
//

#import "FLYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYHouseLockModel : FLYModel

//门锁设备id
@property (nonatomic, strong) NSString * deviceInfoId;
//设备名称
@property (nonatomic, strong) NSString * deviceName;
//IC卡号
@property (nonatomic, strong) NSString * icCardNo;
//是否授权(1=是、2=否)
@property (nonatomic, assign) NSInteger isAuthorize;
//授权密码
@property (nonatomic, strong) NSString * passWord;
//开门方式(1=密码、3=IC卡)
@property (nonatomic, strong) NSMutableArray * openTypeList;

@end

NS_ASSUME_NONNULL_END
