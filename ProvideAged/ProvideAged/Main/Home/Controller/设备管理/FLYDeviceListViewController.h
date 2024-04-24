//
//  FLYDeviceListViewController.h
//  ProvideAged
//
//  Created by fly on 2021/9/9.
//

//设备管理

#import "FLYBaseViewController.h"
#import "FLYElderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYDeviceListViewController : FLYBaseViewController

//设备类型 1房屋  2个人
@property (nonatomic, assign) NSInteger useType;
@property (nonatomic, strong) FLYElderModel * elderModel;

@end

NS_ASSUME_NONNULL_END
