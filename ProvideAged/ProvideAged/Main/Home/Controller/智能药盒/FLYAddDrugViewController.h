//
//  FLYAddDrugViewController.h
//  ProvideAged
//
//  Created by fly on 2022/12/21.
//

#import "FLYBaseViewController.h"
#import "FLYDrugModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYAddDrugViewController : FLYBaseViewController

// 0添加药品  1补充药品
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSString * oldManInfoId;
@property (nonatomic, strong) NSString * deviceId;

// 补充药品时带进来的数据
@property (nonatomic, strong) FLYDrugModel * drugModel;

@end

NS_ASSUME_NONNULL_END
